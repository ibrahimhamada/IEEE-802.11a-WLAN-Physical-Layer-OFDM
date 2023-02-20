close all; clear; clc;
set(0, 'DefaultAxesFontName', 'Roboto Condensed');
set(0, 'DefaultTextFontName', 'Roboto Condensed');
set(0,'DefaultFigureWindowStyle','docked')

% ---------------------------------- %
%        Script for comparing        %
%   BER with and without scrambling  %
%           and interleaving         %
% ---------------------------------- %

% Parameters
filename = 'test_file_1.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');
L = 1000; R = 54; codeRate = 3/4; modulation_type = '64QAM'; rep_type = 'Float'; equalization_method = 'WE';

%Comparison
SNR_dB = [15:1:35];
SNR_lin = 10.^(SNR_dB/10);
BER_WT = [];
BER = [];
r = [];
SCRAMBLER_INIT_STATE = de2bi(93);

for snr = SNR_dB
    snr
    % Frame Construction and Transmitter
    transmitted_frames_WT = Transmitter(data, L, R, codeRate, ...
        modulation_type, rep_type);
    transmitted_frames = Transmitter(data, L, R, codeRate, ...
        modulation_type, rep_type, SCRAMBLER_INIT_STATE);
    
    % Channel
    h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
    transmitted_frames_WT = conv(transmitted_frames_WT,conj(h));
    transmitted_frames_WT = transmitted_frames_WT(1:end-length(h)+1);
    transmitted_frames = conv(transmitted_frames,conj(h));
    transmitted_frames = transmitted_frames(1:end-length(h)+1);
    
    % Noise
    y_WT = awgn(transmitted_frames_WT, snr,'measured');
    y = awgn(transmitted_frames, snr,'measured');
    
    % Receiver
    [decoded_data_WT, rec_frames_WE, eq_rec_fremaes_WE] = Receiver(y_WT, 'WE', ...
        rep_type, snr);
    [decoded_data, rec_frames, eq_rec_fremaes] = Receiver(y, 'WE', ...
        rep_type, snr, SCRAMBLER_INIT_STATE, R);
    
    %BER
    [NUMBER_WT, RATIO_WT] = biterr(decoded_data_WT', data);
    BER_WT = [BER_WT RATIO_WT];
    
    [NUMBER, RATIO] = biterr(decoded_data',data);
    BER = [BER RATIO];
    
end

figure();
semilogy(SNR_dB, BER,'r-o', SNR_dB, BER_WT,'g-o');
title(['BER Performance with and without', ' Interleaving/Scrambling for 64-QAM Modulation and 3/4']);
xlabel('SNR (dB)'); ylabel('BER');
legend('With Interleaving/Scrambling', 'Without Interleaving/Scrambling');
grid on;
