clear; clc; close all

% Add subfolders to path
% Edit with your path
addpath(genpath('C:\Users\cyber\Desktop\New folder'))

%% Transmitter 
clear
clc

SCRAMBLER_INIT_STATE = de2bi(93);

filename='test_file_1.txt'
fileID = fopen(filename,'r')
% message = fscanf(fileID,'%c');
x=fread(fileID, '*ubit1', 'ieee-le');
[x, ~] = scramble(x', SCRAMBLER_INIT_STATE);

% create preamble 
preamble =create_preamble;
preamble =reshape(preamble, 1, length(preamble));

% creat the signal in bits 
L = 16*70
R = 54
codeRate = 3/4
modulation_type= '64QAM'
[NBPSC, NCBPS, NDBPS] = get_interleaving_pars(modulation_type, codeRate)
all_frames = [];
counter=0;
% i+8000 >length(x)
%x=x(1:end-1104);
for i=0:8*L:length(x)

    if i+8000 >length(x)
        data = x(i+1:end);
        data = reshape(data, 1, length(data));

        if isempty(data)
            disp('break')
            break
        end
        
        disp(length(data))
        signal = create_sig(R,(length(x)-i)/8);
        disp((length(x)-i)/8)
    else
    data = x(i+1:i+8000);
    data = reshape(data, 1, length(data));
    signal = create_sig(R,L);
    end

    
    out_signal = convEncoder(signal,1/2);
    complexsignal = mapping(out_signal ,'BPSK');
    signal_ifft_without_cp= ifft(complexsignal);
    % diff=fft(signal_ifft)-complexsignal
    signal_ifft=[signal_ifft_without_cp(end-15:end) signal_ifft_without_cp];

    % data creation: 
    out_data = convEncoder(data,codeRate);
    output_data = padding(out_data,modulation_type);
    disp(length(output_data))
    disp(length(output_data/8))
    interleaved = [];
    for i=1:NCBPS:length(output_data)
        if (i+NCBPS -1) <= length(output_data)
        interleaved = [interleaved, ...
            interleaving(output_data(i:i+NCBPS - 1), NCBPS, NBPSC)];
        else
            interleaved = [interleaved, ...
            interleaving(output_data(i:end), length(output_data(i:end)), NBPSC)];
        end
    end
    out_data = interleaved;
    disp(length(output_data))
    complexdata = mapping(output_data ,modulation_type);

    All_OFDM_data = convert_OFDM_symbol(complexdata);

    frame = create_frame(preamble,signal_ifft,All_OFDM_data);

    disp(length(frame))
    all_frames = [all_frames frame];
    counter = counter+1;
    if i==0
        disp('hereeeeeeeeeeeeeeeeeeeeee')
        test= complexdata;
    end
end    

%% Channel
h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i]; %Channel
%all_frames = conv(all_frames, conj(h));
%all_frames = all_frames(1:end-length(h)+1);
all_frames = filter(h,1,all_frames);


%%  Receiver 
equalization_method = 'WE';
output_filename='output_test_file_333.txt'
output_fileID = fopen(output_filename,'w');
n=1
x_out = []
rec_frame = []
state = SCRAMBLER_INIT_STATE;
while n < length(all_frames)
    pre_sig = all_frames(n:n+401);
    rec_preamble = all_frames(n:n+321);
    rec_sig = pre_sig(323:end);
    sig_without_pref=rec_sig(17:end);

    rec_complexsignal=fft(sig_without_pref);
    rec_complexsignal = reshape(rec_complexsignal, 1, length(rec_complexsignal));

    rec_out_signal = Demapping('BPSK',1/2,rec_complexsignal);
    rec_out_signal = reshape(rec_out_signal, 1, length(rec_out_signal));

    outputStream = Decoder(rec_out_signal,1/2,32);
    

    %Channel Estimaiton%%%%%%%%%%%%%%%%%%
    channel_gains = channel_estimation(rec_preamble);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

    [rec_R , rec_L , M ,C ,P, m]= decode_sig(outputStream);

    bits = 8*rec_L;
    coded_bits = ceil(bits / C);
    all_no_bits = coded_bits+P;
    no_ofdm_sympols = all_no_bits/(48*m);
    end_frame = no_ofdm_sympols*80;

    rec_data =all_frames(n+402:n+401+end_frame);
    rec_data = reshape(rec_data, 1, length(rec_data));

    %rec_frame =[rec_frame all_frames(n:n+401+end_frame)]
    rec_complexdata = inverse_convert_OFDM(rec_data);

    %Channel Equalization%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rec_data_equalized = equalize_channel(rec_complexdata,channel_gains,equalization_method);
    rec_data_equalized =reshape(rec_data_equalized, 1, length(rec_data_equalized));

    out_data = Demapping(M,C,rec_data_equalized);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    out_data = out_data';
    disp(length(out_data))
    disp(length(out_data)/8)
    dinterleaved = [];
    for i=1:NCBPS:length(out_data)
        if (i+NCBPS -1) <= length(out_signal)
        dinterleaved = [dinterleaved, ...
            deinterleaving(out_signal(i:i+NCBPS - 1), NCBPS, NBPSC)];
        else
            dinterleaved = [dinterleaved, ...
            deinterleaving(out_signal(i:end), length(out_signal(i:end)), NBPSC)];
        end
    end
    out_data = dinterleaved';
    %out_data = Demapping(M,C,rec_complexdata');
    % remove padding
    out_data=out_data(1:end-P);
    out_data =reshape(out_data, 1, length(out_data));
    

    outputStream_data = Decoder(out_data,C,bits);
    x_out=[x_out outputStream_data];
    [outputStream_data, state] = descramble(outputStream_data, state);

    y=fwrite(output_fileID, outputStream_data,'*ubit1', 'ieee-le');

    % rec_frame= all_frames(1:402+end_frame);
    n = n+402+end_frame; % for a new frame 

    disp(n)

end

