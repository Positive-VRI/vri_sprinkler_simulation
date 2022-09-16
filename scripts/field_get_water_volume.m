function [volume] = field_get_water_volume(field, x, y)
  ix = (x / field.cell_size) + 1;
  iy = (y / field.cell_size) + round(field.y_num/2) + 1;
  if (0 <= ix && ix <= rows(field.water) && 0 <= iy && iy <= columns(field.water))
    volume = field.water(ix,iy);
  else
    volume = 0;
  end
end