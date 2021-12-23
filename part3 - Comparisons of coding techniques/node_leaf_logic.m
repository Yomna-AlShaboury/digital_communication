function [ r ,  u_hat, u ] = node_leaf_logic( r , u_hat, u , k, n , i )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

% r     : coded data
% u_hat : bleaf for u
% u     : mapped data
% k     : number of input data bits to be coded at a time
% n     : number of coded data chips
% i     : counter to iterate on binary tree nodes

if (i < n)              % not leaf
    % divide r in 2 halvs: a & b
    a = r(1 :end /2);
    b = r(end/2+1 :end);
    
    % left logic
    out_left = sign(a).*sign(b).*min(abs(a),abs(b));
    [left_leaf ,u_hat_L, u] = node_leaf_logic(out_left, u_hat, u, k, n, i*2);
    
    % right logic
    out_right = b+(1-2*u_hat_L).*a;
    [right_leaf, u_hat_R, u] = node_leaf_logic(out_right, u_hat, u, k, n, (i*2)+1);
    
    % up logic
    u_hat = [mod(u_hat_L + u_hat_R , 2) u_hat_R];
    r = [left_leaf right_leaf];

% leaf
else
    Qn = reliability_sequence(n);
    frozen = Qn(1:n-k);
    if any(frozen == (i-(n-1))) || (r(1)>= 0)
        u_hat = [u_hat 0];
        u = [u 0];
    else
        u_hat = [u_hat 1];
        u = [u 1];
    end
end
end