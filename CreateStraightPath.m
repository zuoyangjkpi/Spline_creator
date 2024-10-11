close all
clear
clc

V_A = 27;  % Airspeed in [m/s]

lat_start = 48.0532;
lon_start = 9.38008;

lat_end = 48.051771;
lon_end =  9.365447;

z_start = 855;
z_end = 855;

%%
[x_end, y_end, ~] = LL2UTM(lat_end, lon_end);
[x_start, y_start, ~] = LL2UTM(lat_start, lon_start);
L = norm([x_start, y_start, z_start] - [x_end, y_end, z_end]);
chi = atan2((x_end-x_start),(y_end-y_start));
gamma = atan2((z_end-z_start),norm([x_start, y_start] - [x_end, y_end]));

Mission_Straight.Coeffs4      = [V_A, 0, 0, 0];
Mission_Straight.Type4       = 1;
Mission_Straight.ExitValue   = L;
Mission_Straight.ExitCond    = 0;
Mission_Straight.UTMLong     = 63;
Mission_Straight.UTMArea     = floor(y_start/1000000)+10;
Mission_Straight.SpLength    = L;
Mission_Straight.SplineIndex = 1;
Mission_Straight.CoeffsXYZ   = [x_start, cos(gamma)*sin(chi),0,0, y_start-1000000*floor(y_start/1000000), cos(gamma)*cos(chi),0,0, z_start, sin(gamma),0,0];

save Splines_Mengen_Straight Mission_Straight;
%%
% Define a custom set of distinct colors (you can adjust these)
customColors = [
    0.9 0.5 0; % Orange
];

numColors = size(customColors, 1);
variable = [0:Mission_Straight.SpLength Mission_Straight.SpLength];

x = Mission_Straight.CoeffsXYZ(1) + Mission_Straight.CoeffsXYZ( 2).*variable + Mission_Straight.CoeffsXYZ( 3).*(variable.^2) + Mission_Straight.CoeffsXYZ( 4).*(variable.^3) + 6378137*(pi/180)*9;
y = Mission_Straight.CoeffsXYZ(5) + Mission_Straight.CoeffsXYZ( 6).*variable + Mission_Straight.CoeffsXYZ( 7).*(variable.^2) + Mission_Straight.CoeffsXYZ( 8).*(variable.^3) + 1000000*(Mission_Straight.UTMArea - 10);
z = Mission_Straight.CoeffsXYZ(9) + Mission_Straight.CoeffsXYZ(10).*variable + Mission_Straight.CoeffsXYZ(11).*(variable.^2) + Mission_Straight.CoeffsXYZ(12).*(variable.^3);

% Get color for the current spline from the custom colors array
color = customColors(1, :);

% Plot the spline
figure()
hold on
grid on
axis equal
fontSize = 18;
plot3(x, y, z, 'Color', color, 'LineWidth', 4)
xlabel('$x$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
ylabel('$y$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
zlabel('$z$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
title('UTM Coordinate System', 'FontSize', fontSize + 2)
set(gca, 'FontSize', fontSize); % Apply font size
radius = 20;  % Sphere for the start point
line_length = 50;  % Length of separating lines between splines
[X_sphere, Y_sphere, Z_sphere] = sphere(20);  % Create a unit sphere with 20 subdivisions for the starting point

% Plot the start point using Mission.CoeffsXYZ (using the first row)
x_start = Mission_Straight.CoeffsXYZ(1, 1) + 6378137*(pi/180)*9;  % X coordinate
y_start = Mission_Straight.CoeffsXYZ(1, 5) + 1000000*5;  % Y coordinate
z_start = Mission_Straight.CoeffsXYZ(1, 9);  % Z coordinate

% Plot the start point using Mission.CoeffsXYZ (using the last row)
x_end = x(end);  % X coordinate
y_end = y(end);  % Y coordinate
z_end = z(end);  % Z coordinate

% Plot the start and end point as a large black sphere
surf(radius*X_sphere + x_start, radius*Y_sphere + y_start, radius*Z_sphere + z_start, ...
     'FaceColor', 'k', 'EdgeColor', 'none');  % 'k' for black color (start point)
surf(radius*X_sphere + x_end, radius*Y_sphere + y_end, radius*Z_sphere + z_end, ...
     'FaceColor', 'r', 'EdgeColor', 'none');  % 'r' for red color (end point)
% Move the text a bit right from the starting point
text(x_start - 250, y_start + 80, z_start, 'Start Point', ...
     'FontSize', fontSize - 2, 'Color', 'k', 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
text(x_end + 20, y_end + 100, z_end, 'End', ...
     'FontSize', fontSize - 2, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
hold off

% Convert [x, y] in [lat,lon]    
[latitide, longitude] = UTM2LL(9, y, x - 6378137*(pi/180)*9);

% 绘制2D飞行路径轨迹
figure;              
geoplot(latitide, longitude, '-b', 'LineWidth', 2);
geobasemap streets;  % 可以选择不同的地图样式，如 'satellite', 'streets', 'topographic'
title('2D Flight Trajectory');