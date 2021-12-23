function [coded_data] = generate_codes(data, next, out)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

coded_data = [];
tmp = zeros(size(data));
state = 0;
for i = 1: length(data)
    tmp(i) = out( data(i)+1, state +1);
    state = next(data(i)+1, state +1);
    coded_data = [coded_data flip(de2bi(tmp(i),3))];
end

end

