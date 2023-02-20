function signal = create_sig(R,L) %% modulation is BPSK and 1/2
% R: rate
switch R
    case 6
        Rate = [1 1 0 1];
        M =1;
        C = 1/2;
    case 9
        Rate = [1 1 1 1] ;
        M = 1;
        C = 3/4;
    case 12
        Rate = [0 1 0 1];
        M = 2;
        C = 1/2;
    case 18
        Rate = [0 1 1 1] ;
        M = 2;
        C = 3/4;
    case 24
        Rate = [1 0 0 1];
        M = 4;
        C = 1/2;
    case 36
        Rate = [1 0 1 1];
        M = 4;
        C = 3/4;
    case 48
        Rate = [0 0 0 1];
        M = 6;
        C = 2/3;
    case 54
        Rate = [0 0 1 1];
        M = 6;
        C = 3/4;
    otherwise 
        disp('Enter a valid Rate value')
        
end 

length = flip(de2bi(L,12)); % 12 bits 
parity =rem(sum([Rate length]),2);
tail = [0 0 0 0 0 0]; % Tail bits are always set to zero 
% get the number of coded bits 

bits = 8*L;
coded_bits = ceil(bits / C);
rem_bits = rem(coded_bits,(48*M));


no_bits =rem((48*M)- rem_bits,(48*M));
pad = flip(de2bi(no_bits,9)); % 9 bits for padding
signal=[Rate length parity tail pad];
end