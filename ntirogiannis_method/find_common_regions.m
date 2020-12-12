function comm_regions_image = find_common_regions(binary_1, binary_2, C)

        binary1_labels = bwlabel(~binary_1,8);
        [x,y] = size(binary_1);
        s1 = regionprops(binary1_labels, 'extrema');
        number_of_regions = numel(s1);


        for count =1:number_of_regions

             [jj,ii] = find(binary1_labels.'== count);
             term1=0; term2=0;
             i_l = length(ii);
             
             for count_ii = 1:i_l
                 for count_jj = 1:i_l

                     term1 = term1 + (~binary_2(ii(count_ii),jj(count_jj)))*(~binary_1(ii(count_ii),jj(count_jj)));
                     term2 = term2 + (~binary_1(ii(count_ii),jj(count_jj)));
                 end
             end

             d(count) = 100*term1./term2;
             if  d(count)>=C
                 d(count) = 1;
             else
                 d(count) = 0;
             end
        end

        comm_regions_image = binary_2;
        for i=1:x
            for j=1:y
                count = binary1_labels(i,j);
                if count~=0 && d(count)==1
                   comm_regions_image(i,j) = binary_1(i,j);
                end
            end
        end


            
