function field_plot_hist(field,xmin,xmax,ymin,ymax,res)
  S_cell = field.cell_size^2;
  idx_x_min = round(xmin / field.cell_size) + 1
  idx_x_max = round(xmax / field.cell_size) + 1
  idx_y_min = round(ymin / field.cell_size) + field.y_num/2
  idx_y_max = round(ymax / field.cell_size) + field.y_num/2
  x = xmin:field.cell_size:xmax;
  y = ymin:field.cell_size:ymax;
  x2 = xmin:res:xmax;
  y2 = ymin:res:ymax;
##  x_len = length(x)
##  y_len = length(y)
##  x2_len = length(x2)
##  y2_len = length(y2)
  
  [X,Y] = meshgrid(x,y);
  [X2,Y2] = meshgrid(x2,y2);
  %X2 = flipud(X2);
  %Y2 = flipud(Y2);
  field_hist = (1000 .* field.water(idx_x_min:idx_x_max,idx_y_min:idx_y_max)' ./ S_cell);
##  X_size = size(X)
##  Y_size = size(Y)
##  hist_size = size(field_hist)
  field_hist = interp2(X, Y, field_hist, X2, Y2, 'linear');
  
  %y2 = flip(y2)
  im = imagesc(x2,flipud(y2),field_hist);
  cb = colorbar("FontSize",8);
  ylabel(cb,'water [mm]');
  %c.FontSize = 16;
  xlabel("x [m]");
  ylabel("y [m]");
  axis equal;
  set(gca, 'FontSize', 8)
  set(gca, 'YDir','reverse') 
end