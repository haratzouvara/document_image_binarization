function binary = final_thresholding_contrast(image, map, sw)

    image = double(image);
    map = double(map);
    [x,y] = size(map);
    E_mean = zeros(x,y);
    N = zeros(x,y);
    binary = zeros(x,y);


     for i =1:x
         for j =1:y
             sum_ = 0; Ne = 0;
             if i-sw>0 && i+sw<=x && j-sw>0 && j+sw<=y
                for ii =i-sw:i+sw
                    for jj =j-sw:j+sw
                         if map(ii,jj)==0  
                             Ne = Ne + 1;
                         end

                         sum_ = sum_ + image(ii,jj)*(1 - map(ii,jj));

                    end
                end
             end
             if sum_==0
                 E_mean(i,j) = 0;
             else
                 E_mean(i,j) = sum_/Ne;
             end
             N(i,j) = Ne;
         end
     end

     n_min = sw;

    for i=1:x
         for j=1:y
             if (N(i,j)>n_min) & (image(i,j)<E_mean(i,j))
                 binary(i,j) = 0;
             else
                 binary(i,j) = 1;
             end
         end
    end
   binary = uint8(255*binary);  