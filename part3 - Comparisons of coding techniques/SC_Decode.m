function [decoded_data] = SC_Decode(encoded_data , k, n)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here


[L ,u_hat, u] = node_leaf_logic(encoded_data , [], [], k, n, 1);
Q = reliability_sequence(n);
decoded_data = u(Q(n-k+1 :end));

end



