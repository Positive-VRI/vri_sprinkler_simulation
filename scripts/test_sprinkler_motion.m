fieldW = 56;    % field half width [m]  usually equal to sprinkler range
fieldL = [170.0, 150.0, 120.0, 180.0];  % lengths of the N field sectors [m]
fieldLTot = sum(fieldL);
% fieldH: 
fieldHR = [380.0, 360.0, 370.0, 280.0];   % water height per surface unit [mm] on right sectors
fieldHL = [410.0, 340.0, 290.0, 350.0];   % water height per surface unit [mm] on left sectors
fieldHRm = 0.001 * fieldHR;   % fieldHR in meters [m]
fieldHLm = 0.001 * fieldHL;   % fieldHL in meters [m]
flowH = 60;                   % water flow per hour [m^3/h]
flowS = flowH / 3600;         % water flow per second [m^3/s]
omegaSweep = pi/180 * 0.10;   % sprikler head turnrate [rad/s]

% Pulling velocity [m / s]
vel = 2 .* flowH ./ (fieldW .* (fieldHRm + fieldHLm));
timeSector = fieldL ./ vel;     % time in each sector [s]
timeTot = sum(timeSector);      % total time [s]
areaSector = fieldL .* fieldW;  % area of left/right sectors [m^2]
alphaMax = 0.5 * pi;            % max angle [rad]

sweepNum = floor((fieldL .* fieldW .* (fieldHRm + fieldHLm) .* omegaSweep) ./ (4.0 .* flowS .* alphaMax));
sweepNumR = floor(sweepNum .* fieldHR ./ (fieldHL + fieldHR));
sweepNumL = sweepNum - sweepNumR;

%disp('\nInitial sweep: sprinkler head looking backward:');
%[t, a, omega] = computeSweep(0, pi/180*185, omegaSweep, pi/180*90, pi/180*180, pi/180*270, 3, 4);
%disp('\nSecond sweep: sprinkler head looking forward:');
%[t, a, omega] = computeSweep(t, a, omega, -pi/180*90, pi/180*0, pi/180*90, 4, 3);

[t, a, omega] = computeSweepSequence(0, 0, omegaSweep, alphaMax, sweepNumR, sweepNumL);

plot(t, 180/pi*a);
