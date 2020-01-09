function [value] = anglediff(angle1,angle2)
%ANGLEDIFF Summary of this function goes here
%   Detailed explanation goes here

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

