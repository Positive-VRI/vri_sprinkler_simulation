function [volume_tot,height_avg] = field_water_volume(field)
% FIELD Returns the water volumes and average heights
%   
%   field_plot(field,type)
%
% Returns the water volumes and average heights for each cell used in simulation.
%
% INPUT:
% - field: the field object.
% 
% OUTPUT:
% - volume_tot: total volume of water fallen in the field;
% - height_avg: average water height fallen in the field.
%
% VRI Sprinkler Simulation
% Copyright (C) 2022 Dario Lodi Rizzini, Gabriele Penzotti.
% 
% vri-sprinkler-simulation is free software: you can redistribute it and/or modify
% it under the terms of the Creative Common License.
%
  volume_tot = sum(sum(field.water));
  height_avg = sum(sum(field.water)) / (field.x_num * field.y_num);
end