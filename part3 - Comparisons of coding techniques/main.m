%% Constants

N_bits = 10000;
data = randi([0 1], 1, N_bits);                             % data to be encoded
p_vec = 0: 0.01: 0.5;                                        % vector of different probabilties of fliping bit

%% Sec 1 (Repetition Code)
L = [3 5 11];                                                      % number of repetions for a single bit
for j = 1: length(L)
    coded_data_rep = repetition_encoder(data, L(j));               % encoded data
    BER_vec_rep = size(p_vec);
    for i= 1: length(p_vec)
        rec_data_rep = BSC(coded_data_rep,1,p_vec(i));          % add noise
        decoded_data_rep = repetition_decoder(rec_data_rep, L(j)); % decoded data
        BER_vec_rep(i) = ComputeBER(data, decoded_data_rep);    % BER
    end
    plot(p_vec, BER_vec_rep,'linewidth',2);
    xlabel('p','fontsize',10);
    ylabel('BER','fontsize',10);
    title('Repetition | BER vs. p');
    legend('L = 3','L = 5','L = 11','fontsize',10)
    hold on
end

%% Sec 2 (Convolutional Code) LTE SYSTEM
polynomial = [133 171 165];                                 % polynomial for LTE system
L = 7;                                                      % number of shift registers in the encoder
k = 1;                                                      % number of input bits at a time
n = 3;                                                      % number of output bits at a time --> n = length(polynomial)
r = k/n;                                                    % code rate

[next, out] = create_trellis(L, polynomial);                % generate trellis output and next states
coded_data_conv = generate_codes(data, next, out);          % encoding

BER_vec_conv = size(p_vec);
for i= 1: length(p_vec)
    rec_data_conv = BSC(coded_data_conv,1,p_vec(i));                    % add noise
    decoded_data_conv = viterbi_decoder(rec_data_conv, next, out, N_bits, L); % decode data
    BER_vec_conv(i) = ComputeBER(data, decoded_data_conv);              % BER
end

figure;
plot(p_vec, BER_vec_conv,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('CONV | BER vs. p');

%% Sec 2 (Convolutional Code) L = 3
polynomial = [4 3 5];                                     % polynomial for L = 3
L = 3;                                                      % number of shift registers in the encoder
k = 1;                                                      % number of input bits at a time
n = 3;                                                      % number of output bits at a time --> n = length(polynomial)
r = k/n;                                                    % code rate

[next, out] = create_trellis(L, polynomial);                % generate trellis output and next states
coded_data_conv_3 = generate_codes(data, next, out);          % encoding
BER_vec_conv_3 = size(p_vec);
for i= 1: length(p_vec)
    rec_data_conv_3 = BSC(coded_data_conv_3,1,p_vec(i));                    % add noise
    decoded_data_conv_3 = viterbi_decoder(rec_data_conv_3, next, out, N_bits, L); % decode data
    BER_vec_conv_3(i) = ComputeBER(data, decoded_data_conv_3);              % BER
end

figure;
plot(p_vec, BER_vec_conv_3,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('CONV | BER vs. p');

%% Sec 3 (Convolutional Code Test) LTE SYSTEM
polynomial = [133 171 165];                                 % polynomial for LTE system
L = 7;
trel_test = poly2trellis(L, polynomial);                                                % trellis
coded_data_conv_test = convenc(data,trel_test);                                         % coded data

BER_vec_conv_test = size(p_vec);
for i= 1: length(p_vec)
    rec_data_conv_test = BSC(coded_data_conv_test,1,p_vec(i));                          % add noise
    decoded_data_conv_test =  vitdec(rec_data_conv_test,trel_test,length(data),'trunc','hard');   % decoded data
    BER_vec_conv_test(i) = ComputeBER(data, decoded_data_conv_test);                    % BER
end

figure;
plot(p_vec, BER_vec_conv_test,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('CONV TEST | BER vs. p');

%% Sec 4 ( Compare repetition and covolutional codes | BER )
figure;
plot(p_vec, BER_vec_rep,'linewidth',2);
hold on
plot(p_vec, BER_vec_conv,'linewidth',2);
hold on
plot(p_vec, BER_vec_conv_3,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('(Repetition vs. Conv)| BER vs. P');
legend('Repetition Code','Convolutional Code, L = 7', 'Convolutional Code, L = 3','fontsize',10)

%% Block Dividing  (RESEARCH)

Block_len = 1000;                                           % Block length
polynomial = [133 171 165];                                 % polynomial for LTE system
L = 7;                                                      % number of shift registers in the encoder
k = 1;                                                      % number of input bits at a time
n = 3;                                                      % number of output bits at a time --> n = length(polynomial)
r = k/n;                                                    % code rate

[next, out] = create_trellis(L, polynomial);                % generate trellis output and next states
coded_data_conv = generate_codes(data, next, out);          % encoding
BER_vec_conv = size(p_vec);
for i= 1: length(p_vec)
    rec_data_conv = BSC(coded_data_conv,1,p_vec(i));                    % add noise
    decoded_data_conv = [];
    for j = 1: N_bits/Block_len
        decoded_data_conv = [decoded_data_conv ,viterbi_decoder(rec_data_conv((( (j-1)*3*Block_len )+ 1): 3*j*Block_len), next, out, Block_len, L)];
    end
        BER_vec_conv(i) = ComputeBER(data, decoded_data_conv);
end

figure;
plot(p_vec, BER_vec_conv,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('CONV | BER vs. p');

%% Polar Codes
N_bits = 500;
data = randi([0 1], 1, N_bits);                                                         % data to be encoded

n = 2*(2^ceil(log2(N_bits)));                                                           % lenght of reliability sequence
k = length(data);
coded_data_polar = polar_encode( data , n );

BER_vec_polar = size(p_vec);
for i= 1: length(p_vec)
    rec_data_polar = BSC(coded_data_polar,1,p_vec(i));                                  % noise
    rec_data_polar(rec_data_polar==1) = -1;    rec_data_polar(rec_data_polar==0) = 1;   % PBSK Modulation
    decoded_data_polar = SC_Decode(rec_data_polar , k, n);                              % Decode
    BER_vec_polar(i) = ComputeBER(data, decoded_data_polar);                            % BER
end
figure;
plot(p_vec, BER_vec_polar,'linewidth',2);
xlabel('p','fontsize',10);
ylabel('BER','fontsize',10);
title('POLAR | BER vs. p');


