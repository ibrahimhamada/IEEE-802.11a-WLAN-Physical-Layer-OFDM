function out=rec_64fft(input)
out =zeros(53,1);
out(1:26)=input(39:64);
out(28:53)=input(2:27);
end