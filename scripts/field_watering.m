function [field] = field_watering(field, sample_x, sample_y, sample_vol)
  assert(size(sample_x) == size(sample_y) && size(sample_x) == size(sample_vol));
  
  nr = rows(sample_x);
  nc = columns(sample_x);
  S = field.cell_size^2;
  
  vec_x = reshape(sample_x, nr*nc, 1);
  vec_y = reshape(sample_y, nr*nc, 1);
  ivol = reshape(sample_vol, nr*nc, 1);
  
  y_num_half = (field.y_num/2);
  ix = round(vec_x / field.cell_size) + 1;
  iy = round(vec_y / field.cell_size) + floor(field.y_num/2) + 1;
  
  field.water = grid_increment(field.water,ix,iy,ivol);
end