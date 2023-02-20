function out=to64fft(input)
out =zeros(64,1);
out(2:27)= input(28:53);
out(39:64)= input(1:26);
end