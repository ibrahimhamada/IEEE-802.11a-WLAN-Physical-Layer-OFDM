function y = interleaving(x, R)
% - Get paramaters for interleaving based on the specific data rate
% - Input:
%   1. x    : Frame of bits/symbol to be interleaved
%   2. R    : Data rate 
% - Outputs:
%   1. y    : Interleaved frame of bits/symbols

y = [];
[Ndbps, Ncbps, ~] = get_interleaving_pars(R);

for i = 1:Ncbps:length(x)
    if (i+Ncbps-1) <= length(x)
        inter = interleave_block(x(i:i + Ncbps - 1), Ncbps, Ndbps);
    else
        inter = x(i:end);
    end
    y = [y inter];
end


% ----------- Helper Function ------------ %
function y = interleave_block(x, Ncbps, Ndbps)
N_rows = 16;       % Rows of the block interleaver
y = zeros(1, length(x));
k = 0:Ncbps - 1;

i = (Ncbps / N_rows)*mod(k, N_rows) + floor(k/N_rows); % First Permutation
z = x(i+1);
s = max(Ndbps/2, 1);
%i=k
j = s*floor(i/s) + mod(i + Ncbps - floor(N_rows.*(i./Ncbps)), s); % Second Permutation
y = x(j+1);