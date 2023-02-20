clc
clear all

% Parameters
filename='test_file_1.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');
figure();
CRv= [1/2, 3/4, 1/2, 3/4, 1/2, 3/4, 2/3, 3/4];
mod_typesv = ["BPSK","BPSK","QPSK", "QPSK", "16QAM", "16QAM", "64QAM", "64QAM"];
Rv = [6, 9, 12, 18, 24, 36, 48, 54];
L = 1000; R = 54; codeRate = 3/4; modulation_type = '64QAM'; rep_type = 'Fixed'; equalization_method = 'WE';
colors = ["k-*","b-o","g-+", "r-x","y-s","k-^","m-d","c-p"]; % fol plotting
%Comparison
SNR_dB = [12:1:15]; 

for o = 1: length(Rv)
    R = Rv(o); codeRate = CRv(o); modulation_type = mod_typesv(o); 
    BER_WE = [];
    for snr = SNR_dB
    %Frame Construction and Transmitter
    transmitted_frames = Transmitter(data, L, R, codeRate, modulation_type, rep_type);
    
    disp(o)
    % Channel
    h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
    transmitted_frames = conv(transmitted_frames,conj(h));
    transmitted_frames = transmitted_frames(1:end-length(h)+1);
    
    % Noise
    y = awgn(transmitted_frames.data, snr,'measured');
    y = fi(y,1,8,8);
    %Receiver
    [decoded_data_WE, rec_frames_WE, eq_rec_fremaes_WE ] = Receiver(y, 'WE', rep_type, snr);
    
    %BER
    [NUMBER_WE, RATIO_WE] = biterr(decoded_data_WE',data);
    BER_WE = [BER_WE RATIO_WE];
        
    end
    semilogy(SNR_dB, BER_WE, colors(o));
    hold on;
end

hold off;
title('Comparison between BER of all rates (Fixed-point)');
xlabel('SNR (dB)'); ylabel('BER');
legend('BPSK 1/2','BPSK 3/4','QPSK 1/2','QPSK 3/4','16QAM 1/2','16QAM 3/4','64QAM 2/3','64QAM 3/4');
grid on;
xlim([11 15]);


