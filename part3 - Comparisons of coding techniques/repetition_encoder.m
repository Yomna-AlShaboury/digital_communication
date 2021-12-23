function [coded_data] = repetition_encoder(data, L)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
coded_data = zeros(size(data*L));

%%% WRITE YOUR CODE FOR PART 2 HERE
for i = 1:length(data)
  coded_data( ((i-1)*L)+1 : (i*L) ) = data(i);
end
end

