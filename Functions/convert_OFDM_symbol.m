function All_OFDM_symbol = convert_OFDM_symbol(complex_symbols)

All_OFDM_symbol=[];
for i = 0:48:length(complex_symbols)-48
    
    %OFDM_symbol = datainputs_to_IDFT(complex_symbols((i+1):(i+48)));
    OFDM_symbol = datainputs_to_IDFT(complex_symbols(i+1:i+48));
    OFDM_symbol=[OFDM_symbol(end-15:end)  OFDM_symbol];
    All_OFDM_symbol=[All_OFDM_symbol OFDM_symbol];
    
end 

end

