function [NBPSC, NCBPS, NDBPS] = get_interleaving_pars(R)
% - Get paramaters for interleaving based on the specific data rate
% - Input:
%   1. R    : Data rate (Mbps)
% - Outputs:
%   1. NBPSC: Coded bits per subcarrier
%   2. NCBPS: Coded bits per OFDM symbol
%   3. NDBPS: Data bits per OFDM symbol

switch R
    case 6
        NBPSC = 1;
        NCBPS = 48;
        NDBPS = 24;
    case 9
        NBPSC = 1;
        NCBPS = 48;
        NDBPS = 36;
    case 12
        NBPSC = 2;
        NCBPS = 96;
        NDBPS = 48;
    case 18
        NBPSC = 2;
        NCBPS = 96;
        NDBPS = 72;
    case 24
        NBPSC = 4;
        NCBPS = 192;
        NDBPS = 96;
    case 27
        NBPSC = 4;
        NCBPS = 192;
        NDBPS = 144;
    case 36
        NBPSC = 4;
        NCBPS = 192;
        NDBPS = 108;
    case 48
        NBPSC = 6;
        NCBPS = 288;
        NDBPS = 192;
    case 54
        NBPSC = 6;
        NCBPS = 288;
        NDBPS = 216;
    otherwise
        Error('This Data Rate is not supported');
end
end


