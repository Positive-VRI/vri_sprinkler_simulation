x1 = [(-1).^(1:9), (-1).^(1:7), (-1).^(1:7), (-1).^(1:7), (-1).^(1:6), -ones(1,6)];
x1 = [zeros(1,length(x1)); x1];
x1 = reshape(x1, 1, prod(size(x1)));

x2 = [(-1).^(1:4), +ones(1,2)];
x2 = [zeros(1,length(x2)); x2];
x2 = reshape(x2, 1, prod(size(x2)));

x3 = [(-1).^(1:4), 1, (-1).^(1:4), 1, (-1).^(1:4), 1];
x3 = [zeros(1,length(x3)); x3];
x3 = reshape(x3, 1, prod(size(x3)));

x4 = [(-1).^(0:4), (-1).^(0:4), (-1).^(0:4), (-1).^(0:2), (-1).^(0:4)];
x4 = [zeros(1,length(x4)); x4];
x4 = reshape(x4, 1, prod(size(x4)));

x5 = [(-1).^(0:4), ones(1,6)];
x5 = [zeros(1,length(x5)); x5];
x5 = reshape(x5, 1, prod(size(x5)));

x = [x1, x2, x3, x4, x5];

left_count = cumsum(x > 0);
right_count = cumsum(x < 0);

angle = 90 * [x1, x2, x3, x4, x5]; % [deg]
n = length(angle);        
time = 52.5 * (0:(n-1));  % [s]
v_m_s = 8.5227 * 10^(-3); % [m/s]
dist = v_m_s * time;
idx = find(dist > 80.0);
dist(idx) = 80;

% https://stackoverflow.com/questions/58288993/convert-length-of-time-to-minute-format
plot(time,angle,'b');

sprinkler_angle = [time', dist', angle'];
%save("-ascii", "sprinkler_angle");
%sprinkler_angle_csv = {time, dist, angle};
csvwrite("sprinkler_angle.csv", sprinkler_angle)

