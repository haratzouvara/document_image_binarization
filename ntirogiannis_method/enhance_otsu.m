function output= enhance_otsu(O)
 
    %%% calculate heights
    O = ~O;
    [image_label,~] = bwlabel(O,8);
    regions = regionprops(image_label, 'BoundingBox');
    number_of_regions = numel(regions);
    bound_box = {regions.BoundingBox};
    BOX = cell2mat(bound_box);
    heights = BOX(4:4:length(BOX));
    

    number_of_foreground = sum(sum(O==1));   
    
    
    height_value_number(1,1) = heights(1);
    height_value_number(2,1) = 0;
    height_value_number(3,1) = 0;
    size_of_height_value_number = 1;
    
    for i=1:length(heights)
       flag=0;
        for j=1:size_of_height_value_number

           if height_value_number(1,j) == heights(i)

               height_value_number(2,j)=height_value_number(2,j)+1;
               flag = 1;
           end
         end

         if flag==0
              size_of_height_value_number= size_of_height_value_number+1;
              height_value_number(1,size_of_height_value_number) = heights(i);
              height_value_number(2,size_of_height_value_number) =  1;
         end
     end


    for count = 1:length(heights)

          current_height=heights(count);
          for count_ = 1:length(height_value_number(1,:))

              if current_height == height_value_number(1,count_)
              height_value_number(3,count_) = height_value_number(3,count_) + current_height;

              end
          end
    end
     
     % calculate Rp and Rc  
     Rp = zeros(length(height_value_number(1,:)),2);  Rc = zeros(length(height_value_number(1,:)),2);

     Rp(:,1)=height_value_number(3,:)/number_of_foreground;
     Rp(:,2)=height_value_number(1,:);
   
     Rc(:,1)=height_value_number(2,:)/number_of_regions;
     Rc(:,2)=height_value_number(1,:);
   
     order_values = sortrows(height_value_number',1);
   
     sum_of_div_Rc_Rp=0;

    for i =1:length(order_values)

           for m =1:length(height_value_number)
              if Rc(m,2)==order_values(i,1)
                  sum_of_div_Rc_Rp = sum_of_div_Rc_Rp+Rp(m,1)/Rc(m,1);
              end
           end
           if sum_of_div_Rc_Rp>1
              final_height_thresh = order_values(i);
              break;
           end
    end
    
    
    output=O;
    
    for count = 1:length(heights)
        
        current_height = heights(count);    
        if current_height < final_height_thresh 
            [jj,ii] = find(image_label.'==count);  
            output(ii,jj) = 0;
        end
    end


    output = ~output;
%figure, imshow(teliki_eikona)

















 
    
    
    
    
    
    

