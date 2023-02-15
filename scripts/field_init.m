function [field] = field_init(length, width, cell_size, x_num, y_num)
% FIELD structure initialization
%   
%   [field] = field_init(length, width, cell_size, x_num, y_num)
%
% Initializes the structure field containing the parameters to simulate the 
% irrigation of a field. 
%
% INPUT:
% - length: length of the field measured along the sprinkler moving direction 
%   (axis x);
% - width: width of the field measured crosswise to sprinkler motion direction
%   (axis y); 
% - cell_size: dimension of square cells to build a water historgram; 
% - x_num: number of histogram cells along the axis x; 
%   x_num is independent from the field size, e.g. to assess how much water 
%   falls outside the field area;
% - y_num: number of histogram cells along the axis y; 
%   y_num is independent from the field size, e.g. to assess how much water 
%   falls outside the field area;
%
% OUTPUT:
% -field: a field structure
%
%
% VRI Sprinkler Simulation
% Copyright (C) 2022 Dario Lodi Rizzini, Gabriele Penzotti.
% 
% vri-sprinkler-simulation is free software: you can redistribute it and/or modify
% it under the terms of the Creative Common License.
%
  field = struct ( ...
    "x_num", x_num,  
    "y_num", y_num,  
    "cell_size", cell_size,
    "length",length,
    "width",width,
    "x_min",0,
    "x_max",x_num*cell_size,
    "y_min",-y_num*cell_size/2,
    "y_max",+y_num*cell_size/2,
    "water", zeros(x_num, y_num),
    "area_len", zeros(0, 2),
    "area_water_targets", zeros(0, 2)
  );
end