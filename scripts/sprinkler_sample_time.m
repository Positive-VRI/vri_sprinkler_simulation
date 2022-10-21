function [X, Y, W] = sprinkler_sample_time(sprinkler, time)
  [X, Y, W] = sprinkler_sample_volume(sprinkler, sprinkler.flow * time);
end 