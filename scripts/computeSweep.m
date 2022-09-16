function [t, a, omega] = computeSweep(t, a, omega, angleR, angleM, angleL, sweepNumR, sweepNumL)
  timeStart = t(end);
  angleStart = a(end);
  omegaStart = omega(end);
  sweepTime = abs(2 * (angleL - angleR) / omegaStart)
%  t = timeStart;
%  a = angleStart;
%  omega = [omegaStart];
  
  disp(['angleStart[deg] ' num2str(180/pi*angleStart) ', angleR[deg] ' num2str(180/pi*angleR) ...
        ', angleM[deg] ' num2str(180/pi*angleM) ', angleL[deg] ' num2str(180/pi*angleL)]);
  disp(['to angleR[deg] ' num2str(180/pi*(angleR - angleStart)) ...
      ', to angleM[deg] ' num2str(180/pi*(angleM - angleStart)) ...
      ', to angleL[deg] ' num2str(180/pi*(angleL - angleStart))]);
  
  % Compute the initial step to reset sweep count.
  % We need to reach the middle configuration (angleM) either going to it or 
  % reaching first angleR or angleL. 
  timeToR = (angleR - angleStart) / omegaStart
  if (timeToR < 0)
    timeToR = timeToR + sweepTime;
  endif
  timeToM = (angleM - angleStart) / omegaStart
  if (timeToM < 0) 
    timeToM = timeToM + 0.5 * sweepTime;
  endif
  timeToL = (angleL - angleStart) / omegaStart
  if (timeToL < 0)
    timeToL = timeToL + sweepTime;
  endif
  disp(['timeToR ' num2str(timeToR) ', timeToM ' num2str(timeToM) ', timeToL ' num2str(timeToL)]);
  
  % Next event:
  if (timeToR < timeToM && timeToR < timeToL) 
    t = [t, t(end) + timeToR, t(end) + timeToM];
    a = [a, angleR, angleM];
    omega = [omega, -omegaStart, -omegaStart];
  elseif (timeToL < timeToM && timeToL < timeToR) 
    t = [t, t(end) + timeToL, t(end) + timeToM];
    a = [a, angleL, angleM];
    omega = [omega, -omegaStart, -omegaStart];
  else
    t = [t, t(end) + timeToM];
    a = [a, angleM];
    omega = [omega, omegaStart];
  endif
  
  % From here we plan starting from sprinkler head in angleM and turning direction
  % given by omega(end).
  
  ir = 0;
  il = 0;
  while (ir < sweepNumR && il < sweepNumL)
    % The next angle to be reached, either angleR or angleL, in principle depends on the 
    % sign of the last angular velocity value omega(end).
    % However, we must also take into account the counter of desired sweep number. 
    omegaLast = omega(end);
    if (omegaLast > 0)
      if (il * sweepNumR <= ir * sweepNumL)
        t = [t, t(end) + 0.25 * sweepTime, t(end) + 0.5 * sweepTime];
        a = [a, angleL, angleM];
        omega = [omega, -omegaLast, -omegaLast];
        il = il + 1;
      else
        % Else half sweep on left is skipped.
        omega(end) = -omegaLast;
      endif
    else
      if (ir * sweepNumL <= il * sweepNumR)
        t = [t, t(end) + 0.25 * sweepTime, t(end) + 0.5 * sweepTime];
        a = [a, angleR, angleM];
        omega = [omega, -omegaLast, -omegaLast];
        ir = ir + 1;
      else
        % Else half sweep on left is skipped.
        omega(end) = -omegaLast;
      endif
    endif
  endwhile
endfunction