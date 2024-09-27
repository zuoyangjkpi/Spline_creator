%%
%
% DO NOT RUN WITHOUT READING THE "READ ME" FILE FIRST!
%
%%
clear
close all
clc

fprintf(['\n',repmat('=',1, 85),'\n']);
fprintf('Select Data Addresses File\n');
fprintf([repmat('=',1, 85),'\n']);

curr_dir = dir(fullfile(pwd,'\\WayPoints*.txt'));

if (length(curr_dir)>1)
    % Select file
    fprintf('\nPlease select the desired storage file:\n\n');
    fprintf('   0: Abort Operation\n');
    for i = 1:length(curr_dir)
        fprintf('   %i: %s\n',i,curr_dir(i).name);
    end
    
    selected = 0;
    while selected == 0
        selection = input('\nWhich is the desired file?: ');
        if (length(selection) > 1) || (length(selection) == 1 && (selection > length(curr_dir) || mod(selection,1) || selection < 0)) || ~isnumeric(selection)
            fprintf(2, '\nPlease enter only one valid numeric value\n');
        elseif selection ~= 0
            fprintf('\n   Selected: %s\n\n', curr_dir(selection).name);
            selected = 1;
        elseif selection == 0
            fprintf('\nTerminating\n\n');
            return;
        else
            fprintf(2, '\nPlease enter a value\n');
        end
    end
else
    selection = 1;
end

Err_id = system(sprintf('Path_Planner_new.exe Aircraft_X.txt %s', curr_dir(selection).name));

if (Err_id~=0)
    error('%i',Err_id);
end

mis_id = sscanf(curr_dir(selection).name(11:end), '%d');

%%
clear curr_dir selection selected

curr_dir = dir(fullfile(pwd,sprintf('\\Splines_%02d_*.txt',mis_id)));

if (length(curr_dir)>1)

    fprintf(['\n',repmat('=',1, 85),'\n']);
    fprintf('Select Data Addresses File\n');
    fprintf([repmat('=',1, 85),'\n']);
    
    % Select file
    fprintf('\nPlease select the desired storage file:\n\n');
    fprintf('   0: Abort Operation\n');
    for i = 1:length(curr_dir)
        fprintf('   %i: %s\n',i,curr_dir(i).name);
    end
    
    selected = 0;
    while selected == 0
        selection = input('\nWhich is the desired file?: ');
        if (length(selection) > 1) || (length(selection) == 1 && (selection > length(curr_dir) || mod(selection,1) || selection < 0)) || ~isnumeric(selection)
            fprintf(2, '\nPlease enter only one valid numeric value\n');
        elseif selection ~= 0
            fprintf('\n   Selected: %s\n\n', curr_dir(selection).name);
            selected = 1;
        elseif selection == 0
            fprintf('\nTerminating\n\n');
            return;
        else
            fprintf(2, '\nPlease enter a value\n');
        end
    end
else
    selection = 1;
end

%%
Splines = importdata(sprintf('%s', curr_dir(selection).name), ' ', 1);

n_Splines = size(Splines.data,1);

%% Extraction of loop for Velan

XCoeff      = Splines.data(:, 8:11);

[v, w] = unique( XCoeff(:,1), 'stable' );
duplicate_indices = setdiff( 1:numel(XCoeff(:,1)), w );

min_idx = duplicate_indices(1);

j = 13; % for flat 8s
%j = 17; % for non-flat 8s

XCoeff      = Splines.data(min_idx:(min_idx+j), 8:11);
YCoeff      = Splines.data(min_idx:(min_idx+j),12:15);
ZCoeff      = Splines.data(min_idx:(min_idx+j),16:19);

Mission.Coeffs4      = Splines.data(min_idx:(min_idx+j),20:23);
Mission.Type4       = Splines.data(min_idx:(min_idx+j),2);
Mission.ExitValue   = Splines.data(min_idx:(min_idx+j),7);
Mission.ExitCond    = 0*Splines.data(min_idx:(min_idx+j),7);
Mission.UTMLong     = Splines.data(min_idx:(min_idx+j),3);
Mission.UTMArea     = Splines.data(min_idx:(min_idx+j),4);
Mission.SpLength    = Splines.data(min_idx:(min_idx+j),7);
Mission.SplineIndex = [1:j+1]';
Mission.CoeffsXYZ   = [XCoeff, YCoeff, ZCoeff];

% clear Splines i n_Splines variable x y z Err_id curr_dir mis_id selection

save Splines_Mengen_Eight Mission;


%%

figure()
hold on
grid on
axis equal
fontSize = 18;

% Define a custom set of distinct colors (you can adjust these)
customColors = [
    0 0 1;   % Blue
    0 1 0;   % Green
    1 0 0;   % Red
    0.5 0.5 0.5;   % Grey
    1 0 1;   % Magenta
    0 1 1;   % Cyan
    0.5 0 0.5; % Purple
    0.9 0.5 0; % Orange
    0.3 0.75 0.93; % Sky Blue
    0.75 0.5 0.75; % Violet
    1 0.5 0.5; % Light Red
    0.4 0.8 0.4; % Light Green
    0.6 0.3 0.3 % Brownish Red
];

numColors = size(customColors, 1);

% Define sphere properties (for start point) and lines
radius = 20;  % Sphere for the start point
line_length = 50;  % Length of separating lines between splines
[X_sphere, Y_sphere, Z_sphere] = sphere(20);  % Create a unit sphere with 20 subdivisions for the starting point

% Loop over each spline segment
for i = min_idx:(min_idx+j-2)
    
    variable = [0:Splines.data(i,7) Splines.data(i,7)];
    
    % Compute x, y, z values
    x = Splines.data(i, 8) + Splines.data(i, 9).*variable + Splines.data(i,10).*(variable.^2) + Splines.data(i,11).*(variable.^3) + 6378137*(pi/180)*(Splines.data(i, 3) - 60)*3;
    y = Splines.data(i,12) + Splines.data(i,13).*variable + Splines.data(i,14).*(variable.^2) + Splines.data(i,15).*(variable.^3) + 1000000*(Splines.data(i, 4) - 10);
    z = Splines.data(i,16) + Splines.data(i,17).*variable + Splines.data(i,18).*(variable.^2) + Splines.data(i,19).*(variable.^3);
    
    % Get color for the current spline from the custom colors array
    colorIdx = mod(i - min_idx, numColors) + 1; % Cycle through the colors if splines exceed the number of colors
    color = customColors(colorIdx, :);
    
    % Plot a short line at the start of the spline (instead of the black ball)
    x_center = Splines.data(i, 8) + 6378137*(pi/180)*(Splines.data(i, 3) - 60)*3;
    y_center = Splines.data(i,12) + 1000000*(Splines.data(i, 4) - 10);
    z_center = Splines.data(i,16);
    
    % Short line to separate the splines
    plot3([x_center, x_center], [y_center, y_center], [z_center, z_center + line_length], 'k', 'LineWidth', 3);

    % Plot the spline
    plot3(x, y, z, 'Color', color, 'LineWidth', 4)
    
    % Add text to mark each spline
    text(x_center - 15, y_center + 25, z_center + line_length, sprintf('%d', i-min_idx+1), ...
     'FontSize', fontSize, 'Color', color, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

xlabel('$x$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
ylabel('$y$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
zlabel('$z$ [m]', 'FontSize', fontSize, 'Interpreter', 'latex');
title('UTM Coordinate System', 'FontSize', fontSize + 2)
set(gca, 'FontSize', fontSize); % Apply font size

% Plot the start point using Mission.CoeffsXYZ (using the first row)
x_start = Mission.CoeffsXYZ(1, 1) + 6378137*(pi/180)*(Splines.data(i, 3) - 60)*3;  % X coordinate
y_start = Mission.CoeffsXYZ(1, 5) + 1000000*(Splines.data(i, 4) - 10);  % Y coordinate
z_start = Mission.CoeffsXYZ(1, 9);  % Z coordinate

% Plot the start point as a large black sphere
surf(radius*X_sphere + x_start, radius*Y_sphere + y_start, radius*Z_sphere + z_start, ...
     'FaceColor', 'k', 'EdgeColor', 'none');  % 'k' for black color (start point)

% Move the text a bit right from the starting point
% text(x_start + 50, y_start + 80, z_start, 'Start Point', ...
%      'FontSize', fontSize - 2, 'Color', 'k', 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

hold off








