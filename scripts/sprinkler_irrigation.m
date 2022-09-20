function [field, timeSim, poseSim, omegaSim, speedSim] = sprinkler_irrigation(sprinkler,field,dt)
  
  angleM = pi/ 180 * 0;
  angleL = pi/180*(+90);
  angleR = pi/180*(-90);
  angleT = (angleL - angleR);
  % Vector of average water level between left areas area_water_targets(1,:)
  % and right areas
  sectorNum = rows(field.area_len); 
  if (sectorNum == 0 | rows(field.area_water_targets) ~= sectorNum) 
    disp(['sectorNum '  num2str(sectorNum)]);
    disp(['size of area_lens ' num2str(rows(field.area_len)) ' x ' num2str(columns(field.area_len))]);
    disp(['size of area_water_targets ' num2str(rows(field.area_water_targets)) ...
     ' x ' num2str(columns(field.area_water_targets))]);
    warning('no water targets set for the given field');
    timeSim = 0;
    angleSim = 0;
    omegaSim = 0;
    speedSim = 0;
    return
  end
  
  waterRight = field.area_water_targets(:,1);
  waterLeft = field.area_water_targets(:,2);
  waterAvg = (waterLeft + waterRight) / 2;
  speed = sprinkler.flow ./ (field.width .* waterAvg);
  
  %
  timeSector = field.area_len ./ speed;   % time in each sector [s]
  timeTot = sum(timeSector);                 % total time [s]
  
  timeSectorCum = cumsum([0; timeSector]);
  xSector = sum(field.area_len) - [0; cumsum(field.area_len)];
  
  % Number of sweeps: total, left and right
  %sweepNum = floor((field.length .* field.width .* waterAvg .* sprinkler.omega) ./ (2 .* sprinkler.flow .* angleT))
  sweepNum = floor((sprinkler.omega .* timeSector) ./ angleT);
  sweepNumR = floor(sweepNum .* waterRight ./ (waterLeft + waterRight));
  sweepNumL = sweepNum - sweepNumR;
  
  t = 0;
  a = 0;
  for k=1:sectorNum
    disp('-----');
    disp(['sector ' num2str(k) ', length ' num2str(field.area_len(k)) ', time ' num2str(timeSector(k)) ...
          ' water right ' num2str(1000 * waterRight(k)) ' left ' num2str(1000 * waterLeft(k)) ' [mm], ' ...
          ' sweep right ' num2str(sweepNumR(k)) ' left ' num2str(sweepNumL(k))]);
    lastIdx = length(t);
    [t, a, omega] = computeSweep(t, a, sprinkler.omega, angleR, 0, angleL, sweepNumR(k), sweepNumL(k));
  end
  
  timeSim = t(1):dt:t(end);
  [angleSim] = interpolate_time(t,a,timeSim);
  [xSim] = interpolate_time(timeSectorCum',xSector',timeSim);
  poseSim = [xSim; 
             zeros(1,length(timeSim)); 
             angleSim];
  
  plot(t, a, 'ob', timeSim, poseSim(3,:),'r')
  
  disp('***** SIMULATION OF IRRIGATION *****');
  t_num = length(timeSim);
  volume_tot = 0;
  for k=2:t_num
    if (mod(k, 30) == 0)
      disp(['time ' num2str(timeSim(k)) '/' num2str(timeSim(t_num)) ' volume_tot ' num2str(volume_tot) ' m^3']);
    end
    sprinkler.x = poseSim(1,k);
    sprinkler.y = poseSim(2,k);
    sprinkler.theta = poseSim(3,k);
    [sample_x, sample_y, sample_vol] = sprinkler_sample_time(sprinkler, timeSim(k)-timeSim(k-1));
    volume_inc = sum(sum(sample_vol));
    volume_tot = volume_tot + volume_inc;
    %[sample_x, sample_y, sample_vol] = sprinkler_single_spray_time(sprinkler, timeSim(k)-timeSim(k-1));
    [field] = field_watering(field, sample_x, sample_y, sample_vol);
    %disp(['  field volume ' num2str(field_water_volume(field)) ' m^3'])
  end
  disp(['time ' num2str(timeSim(k)) '/' num2str(timeSim(t_num)) ' volume_tot ' num2str(volume_tot) ' m^3']);
  disp('***** END OF SIMULATION OF IRRIGATION *****');
  
  %plot(t, a, 'o', timeSim, angleSim, '+')
  
##  timeSim = 0;
##  angleSim = 0;
  omegaSim = 0;
  speedSim = 0;
end