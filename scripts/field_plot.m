function field_plot(field,type)
  if (nargin < 2) 
    type = 'contour';
  end
  x = field.cell_size * (0:field.x_num-1);
  y = field.cell_size * ((0:field.y_num-1) - field.y_num/2);
  x_min = min(x)
  x_max = max(x)
  y_min = min(y)
  y_max = max(y)
  [X, Y] = meshgrid(x,y);
  X = X';
  Y = Y';
  field_water_min = min(min(field.water));
  field_water_max = max(max(field.water));
  %meshz(X,Y,field.water);
  if (strcmp(type,'meshz'))
##    X_size = size(X)
##    Y_size = size(Y)
##    water_size = size(field.water)
    meshz(X,Y,field.water);
  else
    contour(X,Y,field.water,100);
  end
  %axis("equal");
  daspect([max(daspect)*[1 1] 1])
  xlabel("x");
  ylabel("y");
end