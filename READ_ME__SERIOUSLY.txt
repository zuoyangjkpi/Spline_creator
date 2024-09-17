%%
%
% WARNING: not following the instructions will lead to unusable paths
% 1. This script is made to generate an 8-figure loop. Different missions are not possible.
% 2. Remember to adapt the limitations in "Aircraft_X.txt". 
%       DO NOT remove lines. DO NOT change the order.
%       NOTE: the value for the rate of climb and descent (RoC/RoD) needs to be compatible to the forwards speed of the aircraft 
(forward speed NEEDS to be a value larger than both RoC and RoD)
% 3. Remember to change the waypoint coordinates in "Waypoints_01.txt". 
%       Change ONLY the ones with a "2" in the first column. DO NOT change the amount. 
%       Always put one set of coordinates on all the even lines and the other on the odd lines.
%       DO NOT change anything else.
% 4. Open "CreateandPlotSplines.m" and select the right number of splines at line 102 of the file.
%       NOTE: the values of j provided are a best guess, different combinations of bank angle and bank rate might require different values of j. 
%               Use the plot to aid yourself and do not be afraid of running the script multiple times.
% 5. Run "CreateandPlotSplines.m".
% 6. If the plot is in accordance with what was needed, the Splines are in the "SplinesVelan.mat" file
% 7. If there is an error, revert the changes and start over.
% 8. The script assumes that there are no 2 splines starting at the same location before the loop starts.
%       If for some reason this is not true for your mission, try flipping the coordinates from the odd/even lines.
%       If this does not work, you may try changing the coordinates for the waypoints on the lines starting with "1" or "3". 
DO NOT change them by more than 3 degrees.
%
%%