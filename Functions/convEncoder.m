function outputStream = convEncoder(inputStream,codeRate)
zerocounter = 0;
trellis = poly2trellis(7,[133 171]); % g0=[1011011]=133 in octal,g1=[1111001]=171, constraint Length =7
switch codeRate
    case 1/2
        outputStream = convenc(inputStream,trellis);
    case 2/3
        puncpat = [1;1;1;0];
        while mod(length(inputStream),4) ~= 0
            inputStream = [inputStream 0] ;
        end
        outputStream = convenc(inputStream,trellis,puncpat);
        c = length(inputStream ) + ceil(length(inputStream)/2); % for example: if outputStream = 8000 , and coderate 3/4 : ceil(8000/4)= 2667 , 8000+2667 = 10667... = 
        outputStream = outputStream (1:c); 
        
    case 3/4 
        while mod(length(inputStream),6) ~= 0
            inputStream = [inputStream 0] ;
        end
        
        puncpat = [1;1;1;0;0;1];
        outputStream = convenc(inputStream,trellis,puncpat);
        c = length(inputStream ) + ceil(length(inputStream)/3); % for example: if inputStream = 8000 , and coderate 3/4 : ceil(8000/4)= 2667 , 8000+2667 = 10667... = 
        outputStream = outputStream (1:c); 
end
end