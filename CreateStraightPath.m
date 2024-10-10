clear
clc

[x1, y1, ~] = LL2UTM(48.05277, 9.36401);
[x2, y2, ~] = LL2UTM(48.05734, 9.39233);

z1 = 575;
z2 = 1120;

L = norm([x2, y2, z2] - [x1, y1, z1]);

chi = atan2((x1-x2),(y1-y2));
gamma = atan2((z1-z2),norm([x2, y2] - [x1, y1]));

Mission.Coeffs4      = [18, 0, 0, 0];
Mission.Type4       = 1;
Mission.ExitValue   = L;
Mission.ExitCond    = 0;
Mission.UTMLong     = 63;
Mission.UTMArea     = floor(y2/1000000)+10;
Mission.SpLength    = L;
Mission.SplineIndex = 1;
Mission.CoeffsXYZ   = [x2, cos(gamma)*sin(chi),0,0, y2-1000000*floor(y2/1000000), cos(gamma)*cos(chi),0,0, z2, sin(gamma),0,0];

save SplinesNew Mission;
%%
z3 = 910;

L = norm([x2, y2, z3] - [x1, y1, z1]);

chi = atan2((x1-x2),(y1-y2));
gamma = atan2((z1-z3),norm([x2, y2] - [x1, y1]));

Mission.Coeff4      = [18, 0, 0, 0];
Mission.Type4       = 1;
Mission.ExitValue   = L;
Mission.ExitCond    = 0;
Mission.UTMLong     = 63;
Mission.UTMArea     = floor(y2/1000000)+10;
Mission.SpLength    = L;
Mission.SplineIndex = 1;
Mission.CoeffsXYZ   = [x2, cos(gamma)*sin(chi),0,0, y2-1000000*floor(y2/1000000), cos(gamma)*cos(chi),0,0, z3, sin(gamma),0,0];

save SplinesNew_alt Mission;

%%

clear
load('SplinesNew.mat')

[x1, y1, ~] = LL2UTM(48.05277, 9.36401);
[x2, y2, ~] = LL2UTM(48.05734, 9.39233);

z1 = 575;
z2 = 1120;

variable = [0:Mission.SpLength Mission.SpLength];

x = Mission.CoeffsXYZ(1) + Mission.CoeffsXYZ( 2).*variable + Mission.CoeffsXYZ( 3).*(variable.^2) + Mission.CoeffsXYZ( 4).*(variable.^3);
y = Mission.CoeffsXYZ(5) + Mission.CoeffsXYZ( 6).*variable + Mission.CoeffsXYZ( 7).*(variable.^2) + Mission.CoeffsXYZ( 8).*(variable.^3) + 1000000*(Mission.UTMArea - 10);
z = Mission.CoeffsXYZ(9) + Mission.CoeffsXYZ(10).*variable + Mission.CoeffsXYZ(11).*(variable.^2) + Mission.CoeffsXYZ(12).*(variable.^3);

figure()
plot3(x,y,z,'b')
hold on
grid on
plot3(x1,y1,z1,'rx')
plot3(x2,y2,z2,'rx')

%%

% clear
% load('SplinesNew_alt.mat')
% 
% [x1, y1, ~] = LL2UTM(48.05277, 9.36401);
% [x2, y2, ~] = LL2UTM(48.05734, 9.39233);
% 
% z1 = 575;
% z3 = 910;
% 
% variable = [0:Mission.SpLength Mission.SpLength];
% 
% x = Mission.CoeffsXYZ(1) + Mission.CoeffsXYZ( 2).*variable + Mission.CoeffsXYZ( 3).*(variable.^2) + Mission.CoeffsXYZ( 4).*(variable.^3);
% y = Mission.CoeffsXYZ(5) + Mission.CoeffsXYZ( 6).*variable + Mission.CoeffsXYZ( 7).*(variable.^2) + Mission.CoeffsXYZ( 8).*(variable.^3) + 1000000*(Mission.UTMArea - 10);
% z = Mission.CoeffsXYZ(9) + Mission.CoeffsXYZ(10).*variable + Mission.CoeffsXYZ(11).*(variable.^2) + Mission.CoeffsXYZ(12).*(variable.^3);
% 
% figure()
% plot3(x,y,z,'b')
% hold on
% grid on
% plot3(x1,y1,z1,'rx')
% plot3(x2,y2,z3,'rx')