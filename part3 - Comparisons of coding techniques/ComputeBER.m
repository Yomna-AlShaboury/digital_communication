function BER = ComputeBER(bit_seq,rec_bit_seq)
%
% Inputs:
%   bit_seq:     The input bit sequence
%   rec_bit_seq: The output bit sequence
% Outputs:
%   BER:         Computed BER
%
% This function takes the input and output bit sequences and computes the
% BER

%%% WRITE YOUR CODE HERE
diff = num2str(abs(bit_seq - rec_bit_seq));
err_bits_number = count(diff, '1');
BER = err_bits_number/ length(bit_seq);
%%%
