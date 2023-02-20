clc
clear all

% Parameters
filename='test_file_1.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');
L = 1000; R = 54; codeRate = 3/4; modulation_type = '64QAM'; rep_type = 'Float'; equalization_method = 'WE';

%Comparison
SNR_dB = [10:1:30]; 
SNR_lin = 10.^(SNR_dB/10);
BER_ZF = [];
BER_WE = [];
r = [];

for snr = SNR_dB
    
    %Frame Construction and Transmitter
    transmitted_frames = Transmitter(data, L, R, codeRate, modulation_type, rep_type);
    
    
    % Channel
    h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
    transmitted_frames = conv(transmitted_frames,conj(h));
    transmitted_frames = transmitted_frames(1:end-length(h)+1);
    
    % Noise
    y = awgn(transmitted_frames, snr,'measured');
    
    
    %Receiver
    [decoded_data_WE, rec_frames_WE, eq_rec_fremaes_WE ] = Receiver(y, 'WE', rep_type, snr);
    [decoded_data_ZF, rec_frames_ZF, eq_rec_fremaes_ZF ] = Receiver(y, 'ZF', rep_type, snr);
    
    %BER
    [NUMBER_WE, RATIO_WE] = biterr(decoded_data_WE',data);
    BER_WE = [BER_WE RATIO_WE];
    
    [NUMBER_ZF, RATIO_ZF] = biterr(decoded_data_ZF',data);
    BER_ZF = [BER_ZF RATIO_ZF];
    
end

figure();
semilogy(SNR_dB, BER_ZF,'r-o', SNR_dB, BER_WE,'g-o');
title('BER performance of the ZF and WE equalizer for 64QAM modulation and 3/4');
xlabel('SNR (dB)'); ylabel('BER');
legend('WE', 'ZF ');
grid on;

