function [field] = field_init(length, width, cell_size, x_num, y_num)
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