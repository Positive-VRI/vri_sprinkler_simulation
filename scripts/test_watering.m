

sprinkler_pose = [0.0, 0.0, pi/180*(-20)];
sprinkler_flow = 675 * 10^(-3) / 60;    % 675 l/min = 675 * 10^{-3} m^3 /s
sprinkler_omega = pi/180 * 1.714; 
sprinkler_fov = pi/180*10;
sprinkler_range = 44.0;
sprinkler_sigma = 1.0;
sprinkler_res = 1.0;
##sprinkler_fov_num = 3;  % 30
##sprinkler_range_num = 4;  % 6

%sprinkler_init(pose, fov, range, flow, range_sigma, fov_num, range_num)
sprinkler = sprinkler_init(sprinkler_pose, sprinkler_fov, sprinkler_range, ...
              sprinkler_flow, sprinkler_omega, sprinkler_sigma, sprinkler_res);
       
field_length = 120.0;
field_width = 2 * sprinkler_range;
field_cell_size = 2.0;
field_x_num = ceil(1.20 * field_length / field_cell_size);
field_y_num = ceil(1.20 * field_width / field_cell_size);
field = field_init(field_length, field_width, field_cell_size, field_x_num, field_y_num);


dt = 60;   % in [sec]
[sample_x, sample_y, sample_vol] = sprinkler_sample_time(sprinkler, dt);

prod_flow_dt = sprinkler.flow * dt
sum_sample_vol = sum(sum(sample_vol))

##sample_x_vectorized = reshape(sample_x, [prod(size(sample_x)) 1]);
##sample_y_vectorized = reshape(sample_y, [prod(size(sample_y)) 1]);
#plot(sample_x,sample_y,'+')
#axis("equal");

figure(1)
%meshz(sample_x, sample_y, sample_vol)
contour(sample_x, sample_y, sample_vol,20)
set(gca, "fontsize", 24)
xlabel("x")
ylabel("y")
axis("equal");

[field] = field_watering(field, sample_x, sample_y, sample_vol);

figure(2)
field_plot(field);
