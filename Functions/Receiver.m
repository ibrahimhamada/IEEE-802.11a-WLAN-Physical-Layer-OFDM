function [decoded_data, rec_frames1, eq_rec_fremaes1 ] = Receiver(Frames, equalization_method, rep_type, snr)

n=1;
decoded_data = [];
rec_frames1 = [];
eq_rec_fremaes1 = [];

if strcmpi(rep_type,'Fixed')
    %Fixed to floating
    Frames = Frames.data;
end

while n < length(Frames)
    pre_sig = Frames(n:n+401);
    rec_preamble = Frames(n:n+321);
    rec_sig = pre_sig(323:end);
    sig_without_pref=rec_sig(17:end);

    rec_complexsignal=fft(sig_without_pref);
    rec_complexsignal = reshape(rec_complexsignal, 1, length(rec_complexsignal));

    rec_out_signal = Demapping('BPSK',1/2,rec_complexsignal);
    rec_out_signal = reshape(rec_out_signal, 1, length(rec_out_signal));

    outputStream = Decoder(rec_out_signal,1/2,32);

    [rec_R , rec_L , M ,C ,P, m]= decode_sig(outputStream);

    bits = 8*rec_L;
    coded_bits = ceil(bits / C);
    all_no_bits = coded_bits+P;
    no_ofdm_sympols = all_no_bits/(48*m);
    end_frame = no_ofdm_sympols*80;

    rec_data =Frames(n+402:n+401+end_frame);
    rec_data = reshape(rec_data, 1, length(rec_data));
    
    rec_frames = inverse_convert_OFDM(rec_data);
    
    if strcmp(rep_type,'Fixed')
        %Floating to Fixed 
        rec_frames= fi(rec_frames,1,16,12);
        rec_preamble= fi(rec_preamble,1,16,12);
    end
    
    switch(M)
        case 'BPSK'
            mm = 2;
        case 'QPSK'
            mm = 4;
        case '16QAM'
            mm = 16;
        case '64QAM'
            mm = 64;
        otherwise
            mm = 0;
    end
    
    %Channel Estimaiton%%%%%%%%%%%%%%%%%%
    channel_gains = channel_estimation(rec_preamble, rep_type);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Channel Equalization%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eq_rec_fremaes = equalize_channel(rec_frames,channel_gains,equalization_method, rep_type, mm, 10.^(snr/10));
    eq_rec_fremaes =reshape(eq_rec_fremaes, 1, length(eq_rec_fremaes));
    
    if strcmp(rep_type,'Fixed')
        out_data = Demapping(M,C,eq_rec_fremaes.data);    
    else
        out_data = Demapping(M,C,eq_rec_fremaes);
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    %out_data = Demapping(M,C,rec_frames');
    % remove padding
    out_data=out_data(1:end-P);
    out_data =reshape(out_data, 1, length(out_data));

    outputStream_data = Decoder(out_data,C,bits);
    decoded_data = [decoded_data outputStream_data];
    
    rec_frames1 = [rec_frames1 rec_frames];
    eq_rec_fremaes1 = [eq_rec_fremaes1  eq_rec_fremaes];
    
    n = n+402+end_frame; % for a new frame 

end

end