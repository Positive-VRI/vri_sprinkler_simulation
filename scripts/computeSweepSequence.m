function [t, a, omega] = computeSweepSequence(t, a, omega, angleMax, sweepNumR, sweepNumL)
  if (length(sweepNumR) ~= length(sweepNumL)) 
    error(['number of field sectors must be the same: length(sweepNumR) ' num2str(length(sweepNumR)) ...
           ' ~= length(sweepNumL) ' num2str(length(sweepNumL))]);
  endif
  n = length(sweepNumL);
  
  % First sweep: sprinkler head looking toward the hose reel irrigator (i.e. toward the "rotolone")
  angleM = pi/ 180 * 180;
  angleR = angleM - angleMax;
  angleL = angleM + angleMax;
  [t, a, omega] = computeSweep(t, a, omega, angleR, angleM, angleL, sweepNumR(1), sweepNumL(1));
  
  % Next sweeps: sprinkler head looking opposite to the hose reel irrigator (i.e. the "rotolone")
  angleM = pi/ 180 * 0;
  angleR = angleM - angleMax;
  angleL = angleM + angleMax;
  for k = 2:n
    [t, a, omega] = computeSweep(t, a, omega, angleR, angleM, angleL, sweepNumR(k), sweepNumL(k));
  endfor
endfunction