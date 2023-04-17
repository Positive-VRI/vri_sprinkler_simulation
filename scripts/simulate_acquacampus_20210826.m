% VRI Sprinkler Simulation
% Copyright (C) 2022 Dario Lodi Rizzini, Gabriele Penzotti.
% 
% vri-sprinkler-simulation is free software: you can redistribute it and/or modify
% it under the terms of the Creative Common License.
%
% simulate_acquacampus_20210826.m
% -------------------------------------------------------------------
% This Octave script simulate the variable rate irrigation (VRI) achieved 
% through a hose reel rain gun sprinkler. 
% The parameter values as well as the input motion command file 
% "sprinkler_angle_acquacampus_20210826.csv" are set in order to reproduce 
% the experiments performed at Acquacampus, Budrio (BO), Italy 
% by a team of the University of Parma wih the support of consozio del 
% Canale Emiliano-Romagnolo on August 26th 2021.  


% ---------------------------------------------------------
% SPRINKLER INIT
% ---------------------------------------------------------
sprinkler_pose = [80.0, 0.0, pi/180*0];
sprinkler_flow = 675 * 10^(-3) / 60;    % 675 l/min = 675% 10^{-3} m^3 /min
sprinkler_omega = pi/180 * 1.714; 
sprinkler_fov = pi/180*10;
sprinkler_range = 44.0;
sprinkler_sigma = 6.0;
sprinkler_res = 0.10;

sprinkler = sprinkler_init(sprinkler_pose, sprinkler_fov, sprinkler_range, ...
              sprinkler_flow, sprinkler_omega, sprinkler_sigma, sprinkler_res);
  
% ---------------------------------------------------------
% FIELD INIT
% ---------------------------------------------------------

field_length = 120.0;
field_width = 2 * sprinkler_range;
field_cell_size = 0.40;
field_x_num = ceil(1.20 * field_length / field_cell_size)
field_y_num = ceil(1.20 * field_width / field_cell_size)
field = field_init(field_length, field_width, field_cell_size, field_x_num, field_y_num);

% ---------------------------------------------------------
% COMMANDS
% ---------------------------------------------------------

% Load the angles computed and used in the experiment
% 1) sprinkler_angle(:,1): column 1 stores the time in [s]
% 2) sprinkler_angle(:,2): column 2 stores the travelled distance
% 3) sprinkler_angle(:,3): column 3 stores the angle in [deg]
load ../data/sprinkler_angle_acquacampus_20210826.csv;
sprinkler_angle = sprinkler_angle_acquacampus_20210826; 

% Interpolates the values of sprinkler distance and angle according 
% to the desired simulation time step dt_sim (in [s])
dt_sim = 2.0;   
xPerc = 0.05;
yPerc = 0.25;
%cmd_time = sprinkler_angle(1,1):dt_sim:sprinkler_angle(end,1);
%cmd_distance = interpolate_time(sprinkler_angle(:,1)',sprinkler_angle(:,2)',cmd_time);
%cmd_angle = interpolate_time(sprinkler_angle(:,1)',pi/180% sprinkler_angle(:,3)',cmd_time); 
time_sim = sprinkler_angle(1,1):dt_sim:sprinkler_angle(end,1);
%[cmd_angle, cmd_time] = interpolate_swing_time(sprinkler_angle(:,1)',sprinkler_angle(:,3)',time_sim, xPerc, yPerc);
cmd_time = sprinkler_angle(1,1):dt_sim:sprinkler_angle(end,1);
cmd_angle = interpolate_time(sprinkler_angle(:,1)'*pi/180, sprinkler_angle(:,3)',cmd_time); 
cmd_distance = interpolate_time(sprinkler_angle(:,1)',sprinkler_angle(:,2)',cmd_time);

disp(['loaded commands: simulation from time ' num2str(sprinkler_angle(1,1)) ' to ' num2str(sprinkler_angle(end,1)) ' with step ' num2str(dt_sim)]);
disp(['interpolated time from '  num2str(cmd_time(1)) ' to ' num2str(cmd_time(end))]);
disp(['sizes: cmd_time '  num2str(length(cmd_time)) ...
       ', cmd_angle ' num2str(length(cmd_angle)) ...
       ', cmd_distance ' num2str(length(cmd_distance))]);
       
%plot(cmd_time(1:1000), cmd_angle(1:1000))

% ---------------------------------------------------------
% SIMULATION
% ---------------------------------------------------------

t_num = length(cmd_time)
sprinkler_init_x = 80.0;
volume_tot = 0;
for k=2:(t_num-200)
  if (mod(k, 50) == 0)
    disp(['time ' num2str(cmd_time(k)) '/' num2str(cmd_time(t_num)) ' volume_tot ' num2str(volume_tot) ' m^3']);
  end
  sprinkler.x = sprinkler_init_x - cmd_distance(k);
  sprinkler.y = 0.0;
  sprinkler.theta = cmd_angle(k);
  dt_k = cmd_time(k) - cmd_time(k-1);
  [sample_x, sample_y, sample_vol] = sprinkler_sample_time(sprinkler, dt_k);
  volume_inc = sum(sum(sample_vol));
  volume_tot = volume_tot + volume_inc;
  [field] = field_watering(field, sample_x, sample_y, sample_vol);
end

volume_predicted = sprinkler.flow% (cmd_time(end) - cmd_time(1));
disp(['volume_tot ' num2str(volume_tot) '; flow-by-time ' num2str(volume_predicted)]);

volume_field = sum(sum(field.water))

field_plot(field,'meshz')

figure(2);
field_plot_hist(field,0.0,120.0,-20.0,20.0,1.0)
print -color -depsc ../plot/field_water_res1.eps

figure(3);
field_plot_hist(field,0.0,120.0,-20.0,20.0,10.0)
print -color -depsc ../plot/field_water_res10.eps

