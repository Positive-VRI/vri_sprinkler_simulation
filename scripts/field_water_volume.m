function [volume_tot,height_avg] = field_water_volume(field)
  volume_tot = sum(sum(field.water));
  height_avg = sum(sum(field.water)) / (field.x_num * field.y_num);
end