% 
% area_lens: vectors with the length of subareas in the field 
%   along sprinkler pulling direction (axis x)
% area_water_targets: target water quantities in each subareas left and right ones
%
% Example: 
%  area_lens = [170.0, 150.0, 120.0, 180.0];  
%   (the field first area is 170.0 m long, the second 150.0 m, etc.)
%  area_water_targets = ...
%      [80.0, 360.0, 370.0, 280.0; 
%      410.0, 340.0, 290.0, 350.0];
% Water height per surface unit [mm] on left sectors. 
function [field] = field_set_water_target(field,area_lens,area_water_targets)
  assert(length(area_lens) == columns(area_water_targets) & rows(area_water_targets)==2)
  field.area_len = area_lens;
  field.area_water_targets = area_water_targets;
end