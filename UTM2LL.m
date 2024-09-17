function [LatRad, LongRad] = UTM2LL(LongOrigin_Old, North_Old , East_Old)

WGS84_A      = 6378137.0;
WGS84_ECC_SQ = 6.694379990141317e-003;  
EE           = 6.739496742276435e-003;
k0           = 0.9996;

mu = North_Old ./ (6.364902166302433e+006);

phi1Rad = mu + (2.518826584390675e-003) .* sin(2.*mu) ...
             + (3.700949035620495e-006) .* sin(4.*mu)...
             + (7.447813767503832e-009) .* sin(6.*mu);

N1 = WGS84_A ./ sqrt(1 - WGS84_ECC_SQ.*sin(phi1Rad).*sin(phi1Rad) );
T1 = tan(phi1Rad).^2;
C1 = EE*(cos(phi1Rad).^2);
D  = (East_Old - 500000) ./ (N1*k0);

LatRad  = (phi1Rad - (N1.*tan(phi1Rad).*((1 - WGS84_ECC_SQ*sin(phi1Rad).*sin(phi1Rad)).^1.5)/(WGS84_A * (1-WGS84_ECC_SQ))) ...
                    .* (D.*D/2 - (5 + 3*T1 + 10*C1 - 4*C1.*C1 - 9*EE).*D.*D.*D.*D/24 ...
                    + (61 + 90*T1 + 298*C1 + 45*T1.*T1 - 252*EE - 3*C1.*C1).*D.*D.*D.*D.*D.*D/720)) * 180/pi;
LongRad = LongOrigin_Old + ((D - (1 + 2*T1 + C1).*D.*D.*D/6 ...
                          + (5 - 2*C1 + 28*T1 - 3*C1.*C1 + 8*EE + 24*T1.*T1).*D.*D.*D.*D.*D/120) ./cos(phi1Rad) ) * 180/pi;