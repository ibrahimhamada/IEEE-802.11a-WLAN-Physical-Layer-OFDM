function stream_bits = Demapping (modtype,coderate,complexsymbol)
    originalbits = lteSymbolDemodulate(complexsymbol,modtype,'Hard');
%     switch coderate
%         case 1/2
%             no_of_bits = (2000*8) ;
%         case 2/3
%             no_of_bits = (1500*8) ;
%         case 3/4
%             no_of_bits = (1360*8) ;
%     end
%   stream_bits = originalbits(1:no_of_bits);
  
    stream_bits = originalbits;    
    
end

