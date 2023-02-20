function channel_gains = channel_estimation(preamble, rep_type)

% zeros_loc = [1, (28:38)];
data_loc = setdiff(1:53,27);

L = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
L = L(data_loc);

if strcmp(rep_type,'Fixed')
    pp = preamble.data;      
else
    pp = preamble;
end
long_train_symbol_1 = fft(pp(194:257));
long_train_symbol_1 = rec_64fft(long_train_symbol_1);
long_train_symbol_1 = long_train_symbol_1(data_loc);
long_train_symbol_1 = reshape(long_train_symbol_1, 1, length(long_train_symbol_1));
%long_train_symbol_11 = long_train_symbol_1(end:-1:1);

long_train_symbol_2 = fft(pp(258:321));
long_train_symbol_2 = rec_64fft(long_train_symbol_2);
long_train_symbol_2 = long_train_symbol_2(data_loc);
long_train_symbol_2 = reshape(long_train_symbol_2, 1, length(long_train_symbol_2));
%long_train_symbol_22 = long_train_symbol_2(end:-1:1);

h1 = long_train_symbol_1./L; 
h2 = long_train_symbol_2./L;

channel_gains = (h1+h2)./2;

if strcmp(rep_type,'Fixed')
        %Floating to Fixed 
        channel_gains= fi(channel_gains,1,16,12);
end

end