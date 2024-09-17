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

save Splines_Mengen_Eight_Klein Mission;

%%

figure()
hold on
grid on
axis equal

for i = min_idx:(min_idx+j)
    
    variable = [0:Splines.data(i,7) Splines.data(i,7)];
    
    x = Splines.data(i, 8) + Splines.data(i, 9).*variable + Splines.data(i,10).*(variable.^2) + Splines.data(i,11).*(variable.^3) + 6378137*(pi/180)*(Splines.data(i, 3) - 60)*3;
    y = Splines.data(i,12) + Splines.data(i,13).*variable + Splines.data(i,14).*(variable.^2) + Splines.data(i,15).*(variable.^3) + 1000000*(Splines.data(i, 4) - 10);
    z = Splines.data(i,16) + Splines.data(i,17).*variable + Splines.data(i,18).*(variable.^2) + Splines.data(i,19).*(variable.^3);
    
    plot3(x,y,z,'b')
    plot3(Splines.data(i, 8) + 6378137*(pi/180)*(Splines.data(i, 3) - 60)*3, ...
          Splines.data(i,12) + 1000000*(Splines.data(i, 4) - 10), ...
          Splines.data(i,16),'mx','LineWidth',3,'MarkerSize',15);
   
end
