function output=datainputs_to_IDFT(input)
vec =zeros(64,1);

S= input;
for k=0:47
    if k<=4
        km= k-26;
        vec(end+km+1)= S(k+1);
    elseif k>=5 && k<=17
        km= k-25;
        vec(end+km+1)= S(k+1);
    elseif k>=18 && k<=23
        km= k-24;
        vec(end+km+1)= S(k+1);
    elseif k>=24 && k<=29
        km= k-23;
        vec(km+1)= S(k+1);
    elseif k>=30 && k<=42
        km= k-22;
        vec(km+1)= S(k+1);
    elseif k>=43 && k<=47
        km= k-21;
        vec(km+1)= S(k+1);
    end
end
vec(44)=1; % pilot -21
vec(58)=1; % pilot -7
vec(8)=1;  %pilot 7
vec(22)=-1;  %pilot 21

output= ifft(vec);
output =reshape(output, 1, length(output));
%output = vec
end