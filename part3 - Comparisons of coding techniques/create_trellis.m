function [next_states, outputs] = create_trellis(L,polynomial)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

poly_dec = oct2dec(polynomial);                         % convert octal polynomial input to decimal
num_states = (2^L)/2;                                   % number of states
current_state = 0: num_states-1;                        % array of current state values

% next state is a shifted value of the current state (it could be shifted by 0 or 1 depending on the input)
% next states : array of 2 rows with length = current_state
%             [ row 1 -> corresponds for input 0]
%             [ row 2 -> corresponds for input 1]
next_states = zeros(2, length(current_state));          
next_states(1, :) = bitshift(current_state, -1);                        % shift by 0
next_states(2, :) = bitshift(current_state, -1)+ (num_states/2);        % shift by 1

num_out_columns = length(polynomial);                   % number of output columns
outputs = zeros(size(next_states));
val = zeros(size(next_states));

% output generation logic
for i = num_out_columns-1 : -1 : 0
    
    % anding current state with a single polynomial value
    val(1,:) = bitand(current_state, poly_dec(num_out_columns -i));
    val(2,:) = bitand(current_state+ (num_states), poly_dec(num_out_columns -i));
    
    % convert the output into binary form(array of 0s and 1s)
    % add the ones ( if odd  -> 1)
    %              ( if even -> 0)
    val(1, :) = mod(sum(de2bi(val(1,:)), 2), 2);
    val(2, :) = mod(sum(de2bi(val(2,:)), 2), 2);
    
    % shift the first output column to the left by "num_out_columns-1"
    % times, each shift to the left in the binary system is a
    % multiplication by 2 in decimal system
    if i == 0
        outputs = outputs + val;
    else
        outputs = outputs + val*2*i;
    end
end

end

