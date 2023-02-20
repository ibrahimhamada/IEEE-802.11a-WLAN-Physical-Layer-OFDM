clc
clear all
% Parameters
filename='test_file_1.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');
L = 1000; R = 54; codeRate = 3/4; modulation_type = '64QAM'; rep_type = 'Float'; equalization_method = 'WE';
%Noise
SNR_dB = 10;
%Frame Construction and Transmitter
transmitted_frames = Transmitter(data, L, R, codeRate, modulation_type, rep_type);
% Channel
h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
transmitted_frames = conv(transmitted_frames,conj(h));
transmitted_frames = transmitted_frames(1:end-length(h)+1);
% Noise
y = awgn(transmitted_frames, SNR_dB,'measured');    
%Receiver
[decoded_data_WE, rec_frames_WE, eq_rec_fremaes_WE ] = Receiver(y, 'WE', rep_type, SNR_dB);
[decoded_data_ZF, rec_frames_ZF, eq_rec_fremaes_ZF ] = Receiver(y, 'ZF', rep_type, SNR_dB); 
scatterplot(eq_rec_fremaes_WE(1:length(eq_rec_fremaes_ZF)/8));
title('Constellation diagram after WE (64QAM, 3/4) SNR = 10 dB');
xlabel('In-Phase'); ylabel('Quadrature');
scatterplot(eq_rec_fremaes_ZF(1:length(eq_rec_fremaes_ZF)/8));
title('Constellation diagram after ZF (64QAM, 3/4) SNR = 10 dB');
xlabel('In-Phase'); ylabel('Quadrature');

