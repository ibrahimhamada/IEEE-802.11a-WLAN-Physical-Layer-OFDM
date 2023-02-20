function output_complex = inverse_convert_OFDM(inputstream)

output_complex=[];
for i = 0:80:length(inputstream)-80
    % outputstream = inputstream(17:end);  % el bit 16 counted in cp
    output = inverse_datainputs_to_IDFT(inputstream(i+17 : i+80));
    output_complex=[output_complex output];
    
end 

end

