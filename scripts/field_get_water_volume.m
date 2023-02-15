function [volume] = field_get_water_volume(field, x, y)
% FIELD Returns the water volume fo a specific point in the field
%   
%   field_plot(field,type)
%
% Returns the water volume fo a specific point in the field.
%
% INPUT:
% - field: the field object; 
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
  ix = (x / field.cell_size) + 1;
  iy = (y / field.cell_size) + round(field.y_num/2) + 1;
  if (0 <= ix && ix <= rows(field.water) && 0 <= iy && iy <= columns(field.water))
    volume = field.water(ix,iy);
  else
    volume = 0;
  end
end