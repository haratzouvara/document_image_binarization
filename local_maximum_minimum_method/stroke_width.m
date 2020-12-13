function stroke_width = stroke_width(image)

    [r,c] = size(image);
    [image_label,~] = bwlabel(image,8);
    
    width_ = [];
    continue_width = 0;
    count = 1;
    
   for i = 1:r
      for j = 2:c
          if image_label(i,j)~=0
             if image_label(i,j)==image_label(i,j-1) 
                continue_width = continue_width+1;
             else
                 if continue_width>=3 &  continue_width<=21
                    width_(count) = continue_width;
                    continue_width = 0;
                    count = count + 1;
                 end
            end
          end
      end
   end
   
stroke_width = round(sum(width_)/length(width_));
    