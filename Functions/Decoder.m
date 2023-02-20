function outputStream = Decoder(inputStream,codeRate,L)
trellis = poly2trellis(7,[133 171]); % g0=[1011011]=133 in octal,g1=[1111001]=171, constraint Length =7
switch codeRate
    case 1/2
        outputStream = vitdec(inputStream,trellis,1,'trunc','hard');
    case 2/3
        puncpat = [1;1;1;0];
         while mod(length(inputStream),3) ~= 0
           inputStream = [inputStream 0] ;
        end
        outputStream = vitdec(inputStream,trellis,1,'trunc','hard',puncpat);
    case 3/4
        puncpat = [1;1;1;0;0;1];
        while mod(length(inputStream),4) ~= 0
           inputStream = [inputStream 0] ;
        end
        outputStream = vitdec(inputStream,trellis,1,'trunc','hard',puncpat);
        
end

outputStream = outputStream(1:L); % to cancel the zero-padding effect that happend in the encoder

end