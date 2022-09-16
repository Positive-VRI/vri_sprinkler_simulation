% Creates the sprinkler with initial state
sprinkler_pose = [80.0, 0.0, pi/180*0];
sprinkler_flow = 675 * 10^(-3) / 60;    % 675 l/min = 675 * 10^{-3} m^3 /min
sprinkler_omega = pi/180 * 1.714; 
sprinkler_fov = pi/180*10;
sprinkler_range = 44.0;
sprinkler_sigma = 1.0;
sprinkler_res = 0.10;

sprinkler = sprinkler_init(sprinkler_pose, sprinkler_fov, sprinkler_range, ...
              sprinkler_flow, sprinkler_omega, sprinkler_sigma, sprinkler_res);
  
% Creates the field  
field_length = 120.0;
field_width = 2 * sprinkler_range;
field_cell_size = 0.40;
field_x_num = ceil(1.20 * field_length / field_cell_size)
field_y_num = ceil(1.20 * field_width / field_cell_size)
field = field_init(field_length, field_width, field_cell_size, field_x_num, field_y_num);

% Field divided into 2 sectors longway (each sector divided into a left and right area)
area_lens = [60.0;
             20.0];
area_water_targets = [0.01667, 0.01333;   % 16.67 mm right, 13.33 mm left, avg 15.00 mm
                      0.01235, 0.01765];  % 12.35 mm right, 17.65 mm left, avg 15.00 mm
field = field_set_water_target(field, area_lens, area_water_targets);

[field, t, pose, omega, speed] = sprinkler_irrigation(sprinkler, field, 1);

figure(2)
field_plot(field,'meshz')

disp('checking total water balance:')
sprinkler_volume_tot = sprinkler.flow * (t(end)- t(1));
disp(['sprinkler: flow ' num2str(sprinkler.flow)  ' m^3/s, time ' num2str(t(end)- t(1)) ' s, ' ...
   'volume_tot ' num2str(sprinkler_volume_tot) ' m^3']);
   
field_cell_surface = field.cell_size^2;
field_surface_tot = field.x_num * field.y_num * field_cell_surface;
field_water_height_avg = mean(mean(field.water));
volume_field_tot = sum(sum(field.water)) * field_cell_surface;
disp(['field: cell surface ' num2str(field_cell_surface)  ' m^2, ' ...
   'field surface tot ' num2str(field_surface_tot) ' m^2, ' ...
   'avg water height ' num2str(1000 * field_water_height_avg) ' mm, ' ...
   'volume_tot ' num2str(volume_field_tot) ' m^3']);


