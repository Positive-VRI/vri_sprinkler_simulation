% ---------------------------------------------------------
% SPRINKLER INIT
% ---------------------------------------------------------
sprinkler_pose = [80.0, 0.0, pi/180*0];
sprinkler_flow = 675 * 10^(-3) / 60;    % 675 l/min = 675 * 10^{-3} m^3 /min
sprinkler_omega = pi/180 * 1.714; 
sprinkler_fov = pi/180*10;
sprinkler_range = 44.0;
sprinkler_sigma = 1.0;
sprinkler_res = 0.10;

sprinkler = sprinkler_init(sprinkler_pose, sprinkler_fov, sprinkler_range, ...
              sprinkler_flow, sprinkler_omega, sprinkler_sigma, sprinkler_res);
  
% ---------------------------------------------------------
% FIELD INIT
% ---------------------------------------------------------

field_length = 120.0;
field_width = 2 * sprinkler_range;
field_cell_size = 0.40;
field_x_num = ceil(1.20 * field_length / field_cell_size)
field_y_num = ceil(1.20 * field_width / field_cell_size)
field = field_init(field_length, field_width, field_cell_size, field_x_num, field_y_num);

% Field divided into 2 sectors longway (each sector divided into a left and right area)
##area_lens = [60.0;
##             20.0];
##area_water_targets = [0.01667, 0.01333;   % 16.67 mm right, 13.33 mm left, avg 15.00 mm
##                      0.01235, 0.01765];  % 12.35 mm right, 17.65 mm left, avg 15.00 mm
##field = field_set_water_target(field, area_lens, area_water_targets);
##
##[field, t, pose, omega, speed] = sprinkler_irrigation(sprinkler, field, 1);

% ---------------------------------------------------------
% COMMANDS
% ---------------------------------------------------------

% Load the angles computed and used in the experiment
% 1) sprinkler_angle(:,1): column 1 stores the time in [s]
% 2) sprinkler_angle(:,2): column 2 stores the travelled distance
% 3) sprinkler_angle(:,3): column 3 stores the angle in [deg]
load ../plot/sprinkler_angle.csv;

% Interpolates the values of sprinkler distance and angle according 
% to the desired simulation time step dt_sim (in [s])
dt_sim = 5.0;   
cmd_time = sprinkler_angle(1,1):dt_sim:sprinkler_angle(end,1);
cmd_distance = interpolate_time(sprinkler_angle(:,1)',sprinkler_angle(:,2)',cmd_time);
cmd_angle = interpolate_time(sprinkler_angle(:,1)',pi/180 * sprinkler_angle(:,3)',cmd_time); 

disp(['loaded commands: simulation from time ' num2str(sprinkler_angle(1,1)) ' to ' num2str(sprinkler_angle(end,1)) ' with step ' num2str(dt_sim)]);

% ---------------------------------------------------------
% SIMULATION
% ---------------------------------------------------------

t_num = length(cmd_time);
sprinkler_init_x = 80.0;
volume_tot = 0;
for k=2:t_num
  if (mod(k, 50) == 0)
    disp(['time ' num2str(cmd_time(k)) '/' num2str(cmd_time(t_num)) ' volume_tot ' num2str(volume_tot) ' m^3']);
  end
  sprinkler.x = sprinkler_init_x - cmd_distance(k);
  sprinkler.y = 0.0;
  sprinkler.theta = cmd_angle(k);
  dt_k = cmd_time(k) - cmd_time(k-1);
  [sample_x, sample_y, sample_vol] = sprinkler_sample_time(sprinkler, dt_k);
  volume_inc = sum(sum(sample_vol));
  volume_tot = volume_tot + volume_inc;
  [field] = field_watering(field, sample_x, sample_y, sample_vol);
end

volume_predicted = sprinkler.flow * (cmd_time(end) - cmd_time(1));
disp(['volume_tot ' num2str(volume_tot) '; flow-by-time ' num2str(volume_predicted)]);

volume_field = sum(sum(field.water))

field_plot(field,'meshz')

