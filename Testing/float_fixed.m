clc
clear all
% Parameters
filename='test_file_1.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');
L = 1000; R = 36; codeRate = 3/4; modulation_type = '16QAM';
SNR_dB = [10:1:30]; BER_ZF = []; BER_WE = []; BER_ZF_f = []; BER_WE_f = [];

%Floating Point
for snr = SNR_dB
    %Frame Construction and Transmitter
    transmitted_frames = Transmitter(data, L, R, codeRate, modulation_type, 'Float');
    % Channel
    h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
    transmitted_frames = conv(transmitted_frames,conj(h));
    transmitted_frames = transmitted_frames(1:end-length(h)+1); 
    % Noise
    y = awgn(transmitted_frames, snr,'measured');
    %Receiver
    [decoded_data_WE, rec_frames_WE, eq_rec_fremaes_WE ] = Receiver(y, 'WE', 'Float', snr);
    [decoded_data_ZF, rec_frames_ZF, eq_rec_fremaes_ZF ] = Receiver(y, 'ZF', 'Float', snr);
    %BER
    [NUMBER_WE, RATIO_WE] = biterr(decoded_data_WE',data);
    BER_WE = [BER_WE RATIO_WE];
    [NUMBER_ZF, RATIO_ZF] = biterr(decoded_data_ZF',data);
    BER_ZF = [BER_ZF RATIO_ZF];
end

%%
%Fixed Point
for snr = SNR_dB
    %Frame Construction and Transmitter
    transmitted_frames = Transmitter(data, L, R, codeRate, modulation_type, 'Fixed');
    % Channel
    h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
    transmitted_frames = conv(transmitted_frames,conj(h));
    transmitted_frames = transmitted_frames(1:end-length(h)+1); 
    % Noise
    y = awgn(transmitted_frames.data, snr,'measured');
    y = fi(y,1,8,8);
    %Receiver
    [decoded_data_WE_f, rec_frames_WE_f, eq_rec_fremaes_WE_f ] = Receiver(y, 'WE', 'Fixed', snr);
    [decoded_data_ZF_f, rec_frames_ZF_f, eq_rec_fremaes_ZF_F ] = Receiver(y, 'ZF', 'Fixed', snr);
    %BER
    [NUMBER_WE_f, RATIO_WE_f] = biterr(decoded_data_WE_f',data);
    BER_WE_f = [BER_WE_f RATIO_WE_f];
    [NUMBER_ZF_f, RATIO_ZF_f] = biterr(decoded_data_ZF_f',data);
    BER_ZF_f = [BER_ZF_f RATIO_ZF_f];
end
%%
figure();
semilogy(SNR_dB, BER_ZF,'r-*', SNR_dB, BER_WE,'g-o', SNR_dB, BER_ZF_f,'b-*', SNR_dB, BER_WE_f,'k-o');
title('Comparison between BER of floating and fixed point (16QAM, 3/4)');
xlabel('SNR (dB)'); ylabel('BER');
legend('WE_Float', 'ZF_Float', 'WE_Fixed', 'ZF_Fixed');
grid on;

Comparison between the BER performance of the floating-point and fixed-point
implementations for 16QAM modulation, and 3/4 code rate