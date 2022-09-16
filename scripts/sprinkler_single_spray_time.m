function [X, Y, W] = sprinkler_single_spray_time(sprinkler, dt)
  X = sprinkler.x + sprinkler.range * cos(sprinkler.theta);
  Y = sprinkler.y + sprinkler.range * sin(sprinkler.theta);
  W = sprinkler.flow * time;
end
