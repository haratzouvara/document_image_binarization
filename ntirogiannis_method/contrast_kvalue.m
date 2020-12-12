function [C, kvalue] = contrast_kvalue (gray, background_avg, binary)
        
    gray = double(gray);
    background_avg = double(background_avg);
    [x,y] = size(gray);

    binary_skeleton = bwmorph(~binary,'thin',Inf);

    FG=0; BG=0; count=0; count_=0; 

    for i=1:x
        for j=1:y
            if binary_skeleton(i,j)==1
                count = count+1;
                FG = FG+gray(i,j);
                std_FG(count) = gray(i,j);
            else
                count_ = count_+1;
                BG = BG + background_avg(i,j);
                std_BW2(count_) = background_avg(i,j);
            end
        end
    end

    FG = FG/count;
    BG = BG/count_;
    std_1 = std((std_FG));
    std_2 = std((std_BW2));

    C = -50.*log10((FG+std_1)./(BG-std_2));
    kvalue = -0.2 - 0.1*(C/10);

         

