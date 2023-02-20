function [scrambled_bits, state] = scramble(bitstream, initial_state)
% - scrambles the input data bitstream in accordance with the 
%   802.11a standard.
% - Inputs:
%       bitstream   - input bitstream
%       state       - initial state of the scrambler 
%                     (must  be between 0 and 127)
% - Outputs:
%       scrambled_bits - scrambled bitstream

if (nargin < 2) || isempty(initial_state)
  initial_state = [1 0 1 1 1 0 1];
end

state = flip(initial_state);
[~, c] = size(bitstream);
scrambled_bits = zeros(1, c);

for i = 1:size(bitstream, 2)
    x = xor(state(4), state(7));
    state = [x, state(1:end - 1)];
    scrambled_bits(i) = xor(x, bitstream(i));
end
state = flip(state);
