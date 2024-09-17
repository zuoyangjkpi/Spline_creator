%%
clear
close all
clc

fprintf(['\n',repmat('=',1, 85),'\n']);
fprintf('Select Data Addresses File\n');
fprintf([repmat('=',1, 85),'\n']);

curr_dir = dir(fullfile(pwd,'\\Splines_*.txt'));

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

%%
Splines = importdata(sprintf('%s', curr_dir(selection).name), ' ', 1);

n_Splines = size(Splines.data,1);

figure()
hold on
grid on
axis equal

for i = 1:n_Splines
    
    variable = [0:Splines.data(i,7) Splines.data(i,7)];
    
    x = Splines.data(i, 8) + Splines.data(i, 9).*variable + Splines.data(i,10).*(variable.^2) + Splines.data(i,11).*(variable.^3);
    y = Splines.data(i,12) + Splines.data(i,13).*variable + Splines.data(i,14).*(variable.^2) + Splines.data(i,15).*(variable.^3) + 1000000*(Splines.data(i, 4) - 10);
    z = Splines.data(i,16) + Splines.data(i,17).*variable + Splines.data(i,18).*(variable.^2) + Splines.data(i,19).*(variable.^3);
    
    plot3(x,y,z,'b')
    plot3(Splines.data(i, 8), ...
          Splines.data(i,12) + 1000000*(Splines.data(i, 4) - 10), ...
          Splines.data(i,16),'mx','LineWidth',3,'MarkerSize',15)
    
end

x = Splines.data(n_Splines, 8) + Splines.data(n_Splines, 9)*Splines.data(n_Splines,7) + Splines.data(n_Splines,10)*(Splines.data(n_Splines,7).^2) + Splines.data(n_Splines,11)*(Splines.data(n_Splines,7).^3);
y = Splines.data(n_Splines,12) + Splines.data(n_Splines,13)*Splines.data(n_Splines,7) + Splines.data(n_Splines,14)*(Splines.data(n_Splines,7).^2) + Splines.data(n_Splines,15)*(Splines.data(n_Splines,7).^3) + 1000000*(Splines.data(n_Splines, 4) - 10);
z = Splines.data(n_Splines,16) + Splines.data(n_Splines,17)*Splines.data(n_Splines,7) + Splines.data(n_Splines,18)*(Splines.data(n_Splines,7).^2) + Splines.data(n_Splines,19)*(Splines.data(n_Splines,7).^3);
plot3(x,y,z,'mx','LineWidth',3,'MarkerSize',15)
