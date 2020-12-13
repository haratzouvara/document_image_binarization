function [contrast] = contrast_map(image, w)

    image=double(image);
    [x,y] = size(image);
    contrast = zeros(x,y);

    for i= 1:x
        for j= 1:y
            if i-w>0 && i+w<=x && j-w>0 && j+w<=y
               count = 1;
               for ii = -w+i:w+i
                   for jj = -w+j:w+j
                      temp(count) = image(ii,jj);
                      count = count + 1;
                   end
               end

            max_value = max(temp);  min_value = min(temp);
            contrast(i,j) = (max_value - min_value)/(max_value + min_value + 1); 

           end
       end
    end
     
    contrast = 255*mat2gray(contrast);
    contrast = uint8(contrast);
    
