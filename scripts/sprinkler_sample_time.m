function [X, Y, W] = sprinkler_sample_dt(sprinkler, time)
  [X, Y, W] = sprinkler_sample_volume(sprinkler, sprinkler.flow * time);
end 