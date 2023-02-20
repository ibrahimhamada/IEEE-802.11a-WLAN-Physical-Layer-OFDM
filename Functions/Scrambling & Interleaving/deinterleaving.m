function x = deinterleaving(y, R)
% - deinterleaving a bitstream y
% - Input:
%   1. y    : interleaved frame of bits/symbol
%   2. R    : Data rate
% - Outputs:
%   1. x    : deInterleaved frame of bits/symbols

x = [];
[Ndbps, Ncbps, ~] = get_interleaving_pars(R);

for i = 1:Ncbps:length(y)
    if (i+Ncbps-1) <= length(y)
        deinter = deinterleave_block(y(i:i + Ncbps - 1), Ncbps, Ndbps);
    else
        deinter = y(i:end);
    end
    x = [x deinter];
end



% ----------- Helper Function ------------ %
function x = deinterleave_block(y, Ncbps, Ndbps)
N_rows = 16;         % Rows of the block interleaver
j = 0:Ncbps - 1;
s = max(Ndbps/2, 1);
i = s*floor(j/s) + mod(j+floor(N_rows*j/Ncbps),s); % first permutation
k = i;
i = N_rows * k - (Ncbps - 1) * floor(N_rows * (k/Ncbps)); % second permutation
x = y(i+1);