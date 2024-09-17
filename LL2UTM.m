function [X, Y, convergence] = LL2UTM(Lat, Long)

WGS84_A      = 6378137.0;
WGS84_ECC_SQ = 6.694379990141317e-003;  
EE           = 6.739496742276435e-003;
k0           = 0.9996;			

longref = 0.15707963267948966; % 9 degs
% longref = 2.617993877991494e-001; % 15 degs

LatRad  = Lat  * pi/180;
LongRad = Long * pi/180;

N = WGS84_A./sqrt(1-WGS84_ECC_SQ.*sin(LatRad).*sin(LatRad));
T = tan(LatRad).*tan(LatRad);
C = EE*cos(LatRad).*cos(LatRad);
A = cos(LatRad).*(LongRad-longref);
llc2 = (LongRad-longref).*(LongRad-longref).*cos(LatRad).*cos(LatRad);

M = WGS84_A * (9.983242984527954e-001 .*       LatRad ...
            -  2.514607060518705e-003 .* sin(2*LatRad) ...
            +  2.639046594337622e-006 .* sin(4*LatRad) ...
            -  3.418046086595789e-009 .* sin(6*LatRad));

X = k0 .* N .* ( A + ((1-T+C).*A.*A.*A/6) + (( 5 - 18*T + T.*T + 72*C - 58*EE) .*A.*A.*A.*A.*A/120) ) + 500000.0;
Y = k0 .* ( M + N.*tan(LatRad).*( (A.*A/2) + ((5 - T + 9*C + 4*C.*C).*A.*A.*A.*A/24) + ((61 - 58*T + T.*T + 600*C - 330*EE).*A.*A.*A.*A.*A.*A/720)) );

    T19 = (3.333333333333333e-1 + C.*(1.0 + 6.666666666666667e-1 .* cos(LatRad).*cos(LatRad))) ...
        + llc2 .* ((1.333333333333333 + C .* (10.0 + C .* (2.333333333333333e+1 + C .* (22.0 + ...
            C .* (7.333333333333333 - 16.0 .* T) - 40.0 .* T) - 3.333333333333333e+1 .* T) - 10.0 .* T) - T) ...
            + (llc2 .* (5.396825396825397e-2 + (-8.253968253968254e-2 + 6.349206349206349e-3 .* T) .* T)));
    
convergence = ((LongRad-2.617993877991494e-001) .* sin(LatRad) .* ( 1.0 + llc2 .* T19 ));
