xx = randi([0 1],192*3 + 5,1);
y = interleaving(xx', 192, 6)
disp('--------------')
yy = deinterleaving(y, 192, 6)
if isequal(xx', yy)
    disp('Hi')
end

