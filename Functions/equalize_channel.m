function equalized_data = equalize_channel(data,channel_gains,equalization_method,imp_type, mm, SNR)

M = mm;
noise_power = 0;
data_power = 1;

pilots_indecies = [32, 45, 7, 21];
data_indecies = setdiff((1:52), pilots_indecies);
if strcmpi(equalization_method,'ZF')
    %remove pilots channel gains
    data_channel_gains = channel_gains(data_indecies);
    if strcmpi(imp_type,'Fixed')
        for i = 1:48:length(data)
        equalized_data(i:i+47) = divide(numerictype(data_channel_gains),data(i:i+47),data_channel_gains);
        end
    else
        for i = 1:48:length(data)
            equalized_data(i:i+47) = data(i:i+47)./data_channel_gains;
        end
    end
else
    data_channel_gains = channel_gains(data_indecies);
    if strcmpi(imp_type,'Fixed')
        W = divide(numerictype(data_channel_gains),conj(data_channel_gains),((abs(data_channel_gains)).^2+(log2(M)/SNR)));
        for i = 1:48:length(data)
        equalized_data(i:i+47) = data(i:i+47).*W;
        end
    else
        W = conj(data_channel_gains)./((abs(data_channel_gains)).^2 + (log2(M)/SNR));
        for i = 1:48:length(data)
            equalized_data(i:i+47) = data(i:i+47).*W;
        end
    end
    
   
end
end
