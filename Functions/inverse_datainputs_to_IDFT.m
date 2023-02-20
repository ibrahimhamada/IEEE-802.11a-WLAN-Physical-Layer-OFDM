function output=inverse_datainputs_to_IDFT(input)
S= fft(input);
index = [39,40,41,42,43,45,46,47,48,49,50,51,52,53,54,55,56,57,59,60,61,62,63,64,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27];

for k=1:48
    output(k)=S(index(k));
end

new_k = zeros(48,1);

for m=1:64
    if m<8
        km= 22+m;
        new_k(km+1)=S(m);
    elseif m>8 && m<22
        km= 21+m;
        new_k(km+1)=S(m);
    elseif m>22 && m<28
        km= 20+m;
        new_k(km+1)=S(m);
    elseif m>39 && m<44
        km= m-39;
        new_k(km+1)=S(m);
    elseif m>44 && m<58
        km= m-40;
        new_k(km+1)=S(m);
    elseif m>58 
        km= m-41;
        new_k(km+1)=S(m);
    end
end

%output= new_k;
end
 