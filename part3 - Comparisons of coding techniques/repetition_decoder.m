function [decoded_data] = repetition_decoder(coded_data, L)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

decoded_data = zeros(1,length(coded_data)/L);
for i = 1:length(decoded_data)
  decoded_data(i) = mode(coded_data( ((i-1)*L)+1 : (i*L)), 2);
end
end

