function [X, Y, W] = sprinkler_sample_volume(sprinkler, vol)
##  x_half_size = 5 * sprinkler.range_sigma;
##  y_half_size = 0.5 * 2.0 * sprinkler.fov * sprinkler.range;
##  %S = 4 * x_half_size * y_half_size;
##  x_half_num = ceil(x_half_size / sprinkler.res);
##  y_half_num = ceil(y_half_size / sprinkler.res);
##  x_sample = (-x_half_num:x_half_num) * sprinkler.res + sprinkler.range;
##  y_sample = (-y_half_num:y_half_num) * sprinkler.res;
##  [Xtmp, Ytmp] = meshgrid(x_sample,y_sample);
##    
##  X = Xtmp * cos(sprinkler.theta) - Ytmp * sin(sprinkler.theta);
##  Y = Xtmp * sin(sprinkler.theta) + Ytmp * cos(sprinkler.theta);
##  Rho = sqrt(X.^2 + Y.^2);
##  Theta = atan2(Y,X);
##  X = X + sprinkler.x;
##  Y = Y + sprinkler.y;
##  
##  VonMises = exp(sprinkler.fov_kappa .* cos(Theta-sprinkler.theta)) ./ (2 .* pi .* besseli(0,sprinkler.fov_kappa));
##  BRayleigh = exp(-(Rho - sprinkler.range_mu).^2 ./ (2 * sprinkler.range_sigma.^2)) .* Rho;  
##  W = VonMises .* BRayleigh;
##  W = vol * W / sum(sum(W));
  
  X = sprinkler.x + sprinkler.spray_x * cos(sprinkler.theta) - sprinkler.spray_y * sin(sprinkler.theta);
  Y = sprinkler.y + sprinkler.spray_x * sin(sprinkler.theta) + sprinkler.spray_y * cos(sprinkler.theta);
  W = sprinkler.spray_w * vol;
end 