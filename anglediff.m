function [value] = anglediff(angle1,angle2)
%ANGLEDIFF Calculates the difference between 2 angles in radians.
%   Will always provide the shortest signed angle regardless of where the origin is respective to the input.
%   This compensates for when both angles straddle 0 on a circle; a regular difference will yield a very large angle, when this may not be the case.
%   Useful for comparing how close angles are to eachother.

a1 = wrapTo2Pi(angle1);
a2 = wrapTo2Pi(angle2);

if abs(a1-a2) <= pi
    value = a1-a2;
else
    value = 2*pi - (a1-a2);
end

if value == -pi
    value = pi;
end
end
