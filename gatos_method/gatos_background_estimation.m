function background= gatos_background_estimation(image,binary,dx, dy)

%%image --grayscale image, binary -- sauvola binary image, dx -- avg
%%character height, dy --avg stroke width

[x,y] = size(image);         %image size


op_binary = 1 - binary;

II = double(image).*op_binary;

kernel = ones(dx, dy);

sum1 = conv2(double(II), kernel, 'same');
sum2 = conv2(op_binary, kernel, 'same');

background = round(sum1./sum2);
 
for i=1:x
    for j=1:y
        if binary(i,j)==0
            background(i,j) = image(i,j);
        end
    end
end

background = uint8(background);


end

        
