function out=create_preamble()

% short training symbol: 
S= sqrt(13/6) *[0, 0, 1 + 1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1 + 1i, 0, 0, 0, 0, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, 1+1i, 0, 0, 0, 1+1i, 0, 0, 0, 1 + 1i, 0, 0];
%S= linspace(-26,26,53)
vec=to64fft(S);
%V_idft = to64fft(S);
V_idft= ifft(vec);

short_train=[V_idft;V_idft;V_idft(1:33)]; %% concatenate another part 
short_train=round(short_train,3);
%disp(length(short_train))
% long training symbol: 
L = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
%disp(length(L))
vec_long=to64fft(L);
V_long_idft= ifft(vec_long);

%V_long_idft = to64fft(L);
long_time=[V_long_idft;V_long_idft]; 
GI2= long_time(end-31:end);
%disp(length(GI2))
long_train= [GI2 ; long_time; GI2(1)];
long_train= round(long_train,3);
%disp(length(long_train))
% preamble: 
preamble=[short_train; long_train];
out =preamble;

end