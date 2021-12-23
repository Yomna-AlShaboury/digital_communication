function [ encoded_data ] = polar_encode( data , n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

G2 = [1 0; 1 1];              
u = [];                       % mapped data
k = length(data);             % number of data bits
Q = reliability_sequence(n); % reliability sequence for N 

% generate kernel
kernel = G2;
for i = 1: log2(n)-1
    kernel = kron(G2,kernel);
end
u(Q(n-k+1 : end))= data;
encoded_data = mod(u*kernel,2);

end

