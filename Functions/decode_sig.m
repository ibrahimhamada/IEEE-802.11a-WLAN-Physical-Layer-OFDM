function [R , L , M ,C ,P, m]= decode_sig(signal) %% modulation is BPSK and 1/2
Rate = signal(1:4);
length = signal(5:16);
parity = signal(17);
tail = signal(18:23);
pad = signal(24:end);

% check parity bit if error occured 


if Rate == [1 1 0 1]
        R = 6;
        M ='BPSK';
        m= 1;
        C = 1/2;
elseif Rate == [1 1 1 1]
        R = 9;
        M = 'BPSK';
        m=1;
        C = 3/4;
elseif Rate == [0 1 0 1]
        R = 12;
        M = 'QPSK';
        m= 2;
        C = 1/2;
elseif Rate == [0 1 1 1]
        R = 18;
        M = 'QPSK';
        m=2;
        C = 3/4;
elseif Rate == [1 0 0 1]
        R = 24;
        M = '16QAM';
        m=4;
        C = 1/2;
elseif Rate == [1 0 1 1]
        R = 36;
        M = '16QAM';
        m=4;
        C = 3/4;
elseif Rate == [0 0 0 1]        
        R = 48;
        M = '64QAM';
        m=6;
        C = 2/3;
elseif Rate == [0 0 1 1]
        R = 54;
        M = '64QAM';
        m=6;
        C = 3/4;
end
   L = bi2de(length,'left-msb');
   P = bi2de(pad,'left-msb');
end 