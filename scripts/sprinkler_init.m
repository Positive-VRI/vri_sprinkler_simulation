% sprinkler_init(pose, fov, range, flow, range_sigma, res)
% pose: vector of 3 parameters [x, y, theta] of the sprinkler pose
% fov: sprinkler field of view of head water flow 
% range: distance from sprinkler head where the water flow is maximum 
% flow: water volume per second in [m^3/s]
% omega: rotation speed of sprinkler head in [rad/s]
% range_sigma: sigma of biased Rayleigh distribution of water flow
% res: resolution used to represent watering surface
function [sprinkler] = sprinkler_init(pose, fov, range, flow, omega, range_sigma, res);
  % Computing kappa s.t.
  %  exp(k * cos(0.5*fov)) / (2*pi*I_0(k)) = (2*pi*I_0(0))
  %  exp(k * cos(0.5*fov)) = I_0(k)
  %  cos(0.5*fov) = log(I_0(k)) / k
  % Using Abramowitz-Stegun (9.7.1): I_0(k) ~= exp(k) / sqrt(2*pi*k) (large k)
  %  -> log(I_0(k)) ~= k - log( (2*pi*k)^0.5) = k - 0.5 * log( (2*pi*k) )
  fov_tol = 0.15;                         % percentage of maximum
  fov_kappa = log(fov_tol) / (cos(0.5*fov) - 1)  % kappa of von Mises corresponding to fov
  range_mu = range - 3 * range_sigma
  
  assert(length(pose) == 3);
  
##  if (nargin < 8) 
##    fov_num = 20;
##    range_num = 10;
##  endif

  % Compute the sprinkler pattern
  
  range_localized = 1;
  if (range_localized==1)
    %x_half_size = 5 * range_sigma;
    y_half_size = 0.5 * 2.0 * fov * range;
    %x_half_num = ceil(x_half_size / res);
    x_num = ceil((range + 3*range_sigma) / res);
    y_half_num = ceil(y_half_size / res);
    %x_sample = (-x_half_num:x_half_num) * res + range_mu;
    x_sample = (0:x_num) * res;
    y_sample = (-y_half_num:y_half_num) * res;
    [X, Y] = meshgrid(x_sample,y_sample);
    Rho = sqrt(X.^2 + Y.^2);
    Theta = atan2(Y,X);
    VonMises = exp(fov_kappa .* cos(Theta)) ./ (2 .* pi .* besseli(0,fov_kappa));
    BRayleigh = exp(-(Rho - range_mu).^2 ./ (2 * range_sigma.^2)) .* Rho;
    W = VonMises .* BRayleigh;
    W = W / sum(sum(W));
  else 
    y_half_size = 0.5 * 2.0 * fov * range;
    x_num = ceil((range + 3*range_sigma) / res);
    y_half_num = ceil(y_half_size / res);
    x_sample = (0:x_num) * res;
    y_sample = (-y_half_num:y_half_num) * res;
    [X, Y] = meshgrid(x_sample,y_sample);
    Rho = sqrt(X.^2 + Y.^2);
    Theta = atan2(Y,X);
    VonMises = exp(fov_kappa .* cos(Theta)) ./ (2 .* pi .* besseli(0,fov_kappa));
    Rayleigh = exp(-Rho.^2 ./ (2 * range_sigma.^2)) .* Rho ./ range_sigma.^2;
    W = VonMises .* Rayleigh;
    W = W / sum(sum(W));
  end  
  
  sprinkler = struct ( ...
    "x", pose(1),  
    "y", pose(2),  
    "theta", pose(3), 
    "fov", fov, 
    "flow", flow, 
    "omega", omega, 
    "fov_kappa", fov_kappa, 
    "range", range, 
    "range_mu", range_mu, 
    "range_sigma", range_sigma, 
    "res", res,
    "spray_x", X,
    "spray_y", Y,
    "spray_w", W
  );
end