function complexsymbol = mapping(inputbits,modtype)

switch modtype
    case 'BPSK'
        complexsymbol = lteSymbolModulate(inputbits,'BPSK');
    case 'QPSK'
        while mod(length(inputbits),2) ~= 0
            inputbits = [inputbits 0] ;
        end
       complexsymbol = lteSymbolModulate(inputbits,'QPSK');
    case '16QAM'
%         while mod(length(inputbits),4) ~= 0
%             inputbits = [inputbits 0] ;
%         end
        complexsymbol = lteSymbolModulate(inputbits,'16QAM');
    case '64QAM'
        while mod(length(inputbits),6) ~= 0
            inputbits = [inputbits 0] ;
        end
        complexsymbol = lteSymbolModulate(inputbits,'64QAM');
        
end
complexsymbol = reshape(complexsymbol, 1, length(complexsymbol));
end