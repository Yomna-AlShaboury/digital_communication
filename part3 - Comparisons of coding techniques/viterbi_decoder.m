function [retrieved_bits] = viterbi_decoder(data, next, out, N, L)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

kernel = zeros(2^L, L);
%genrate possibilites
for i=1:L
   temp = [zeros(2^L/2^i,1); ones(2^L/2^i,1)];
   kernel(:,i) = repmat(temp,2^(i-1),1);
end

current_state = bi2de(kernel(:, 1:L-1));
current_state = downsample(current_state,2); % current_state = zeros((2^L)/2, 1)

% generate kernel
for i = 1: 2^L
    state = 0;
    for j = 1: L 
        tmp = out( kernel(i, j)+1, state +1);
        state = next(kernel(i, j)+1, state +1);
        kernel(i,j) = tmp;
    end
end
trellis_diagram = [kernel , kron(kernel(:,L),ones(1,N-L))]; % metric = zeros(2^L, N);

for i = 1 : N
    data_decimal(i) = bi2de(flip( data(((i-1)*3) + 1 :i*3)));
end

for i = 1: 2^L
    for j = 1: N
        metric_diagram(i, j) = biterr(data_decimal(j), trellis_diagram(i,j));
    end
end


% Hamming Distance
distance = zeros((2^L)/2, N);
prev_states = zeros((2^L)/2, 2);

for i = 1 :(2^L)/2
    prev_states(i,:) = [find(next(1,:) == current_state(i)) , find(next(2,:) == current_state(i))] - 1;
end

% trans_state
trans_metric = sum(metric_diagram(:,1:L),2);
for i = 1 : (2^L)/2
    distance(i,L) = min( trans_metric(i), trans_metric(i+((2^L)/2)));
end
% steady_state
up_down = zeros(size(distance));
for j = L: N-1
    add = kron(distance(:, j), ones(2,1))+ metric_diagram(:, j+1);
    for i = 1 : (2^L)/2
        distance(i,j+1) = min( add(i), add(i+((2^L)/2)));
        if distance(i,j+1) == add(i+((2^L)/2))
            up_down(i, j+1) = 1;
        end
    end
end


% Traceback

% steady state
retrieved_bits = [];
index = find( distance(:,end) == min(distance(:,end)));
cs = current_state(index);
for i = N: -1: L+1
    if (any(next(2, :) == cs) == 1)
        bit_ = 1;
    else
        bit_ = 0;
    end
    retrieved_bits = [retrieved_bits bit_];
    ps = prev_states(index,:);
    if up_down(index,i) == 0
        ps = ps(1);
    else
        ps = ps(2);
    end
    cs = ps;
    index = find(current_state == cs);
end

% transient state
trans_bits_index= find( trans_metric == distance(index,L))-1;
trans_bits = de2bi(trans_bits_index(end,:),L);
retrieved_bits = [retrieved_bits trans_bits];
retrieved_bits = flip(retrieved_bits);
end

