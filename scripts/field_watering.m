function [field] = field_watering(field, sample_x, sample_y, sample_vol)
  assert(size(sample_x) == size(sample_y) && size(sample_x) == size(sample_vol));
  
  nr = rows(sample_x);
  nc = columns(sample_x);
  S = field.cell_size^2;
  
  vec_x = reshape(sample_x, nr*nc, 1);
  vec_y = reshape(sample_y, nr*nc, 1);
  ivol = reshape(sample_vol, nr*nc, 1);
  
##  plot(vec_x, vec_y, 'o')
##  axis("equal")
  
  y_num_half = (field.y_num/2);
  ix = round(vec_x / field.cell_size) + 1;
  iy = round(vec_y / field.cell_size) + floor(field.y_num/2) + 1;
  idx_inrange = find(1 <= ix & ix <= field.x_num & 1 <= iy & iy <= field.y_num);
  idx_outrange = find(ix < 1 | ix > field.x_num | iy < 1 | iy > field.y_num);
  
  lenght_idx_inrange = length(idx_inrange)
  length_ivol = length(ivol)
  
##  valid = ones(nr*nc,1);
##  indices_xy_vec = [ix iy];
  field_idx = sub2ind(size(field.water), ix(idx_inrange),iy(idx_inrange));
  
  disp('----')
  disp(['samples outside the field limits ' num2str(length(idx_outrange))]);
  
  field_water_element_num = prod(size(field.water))
  field_water_selected_element_num = prod(size(field.water(field_idx)))
  
  volume_field_before = sum(sum(field.water))
  volume_field_idx_before = sum(sum(field.water(field_idx)))
  
  w_before = field.water;
  
  field.water(field_idx) = field.water(field_idx) + ivol(idx_inrange);
  
  w_after = field.water;
  
  changed = find(w_after - w_before > 0);
  changed_num = length(changed)
  
  indices_ix_iy_idx_ivol_before_after = round([ix, iy, field_idx, ivol(idx_inrange), w_before(field_idx), w_after(field_idx)])

  volume_field_after = sum(sum(field.water))  
  volume_field_idx_after = sum(sum(field.water(field_idx)))
  volume_field_inc = volume_field_after - volume_field_before
  volume_field_idx_inc = volume_field_idx_after - volume_field_idx_before
  volume_inc_tot = sum(ivol)
  volume_inc_on_field_tot = sum(ivol(idx_inrange))
  
##  indices_xy_for = [];
##  for r=1:nr
##    for c=1:nc
##      index_x = round(sample_x(r,c) / field.cell_size) + 1;
##      index_y = round(sample_y(r,c) / field.cell_size) + (field.y_num/2) + 1;
##      if (1 <= index_x && index_x <= field.x_num && 
##          1 <= index_y && index_y <= field.y_num)
##        indices_xy_for = [indices_xy_for; index_x index_y (sample_vol(r,c)/S)];
##        field.water(index_x,index_y) = field.water(index_x,index_y) + sample_vol(r,c)/S;
##        disp([sample_x(r,c), sample_y(r,c), index_x, index_y]) 
##      end
##    end
##  end
##  field.water(indices_xy_for(:,1),indices_xy_for(:,2)) = ...
##    field.water(indices_xy_for(:,1), indices_xy_for(:,2)) + indices_xy_for(:,3);
##  
##  size_indices_vec = size(indices_xy_vec(idx_inrange,:))
##  size_indices_for = size(indices_xy_for)
##    
##  figure(3)
##  plot(indices_xy_vec(idx_inrange,1),indices_xy_vec(idx_inrange,2), 'bo', indices_xy_for(:,1),indices_xy_for(:,2), 'r+');
end