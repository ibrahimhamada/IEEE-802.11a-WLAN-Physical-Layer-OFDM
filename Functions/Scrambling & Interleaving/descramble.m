function [descrambled_bits, state] = descramble(scrambled, initial_state)
% - descrambles the scrabled data bitstream in accordance with the 
%   802.11a standard.
% - Inputs:
%       bitstream   - input bitstream
%       state       - initial state of the scrambler 
%                     (must  be between 0 and 127)
% - Outputs:
%       descrambled_bits - scrambled bitstream

if (nargin < 2) || isempty(initial_state)
  initial_state = [1 0 1 1 1 0 1];
end
state = initial_state;
[~, c] = size(scrambled);
descrambled_bits = zeros(1, c);
for i = 1:size(scrambled, 2)
    x = xor(state(4), state(7));
    state = [x, state(1:end-1)];
    descrambled_bits(i) = xor(x, scrambled(i));
end

