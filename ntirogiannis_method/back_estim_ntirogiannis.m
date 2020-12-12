function [background_min, background_avg]= back_estim_ntirogiannis(gray,binary)

    gray = double(gray);
    [x_gray,y_gray]=size(gray);

    image=padarray(gray,[1 1],'replicate');
    binary=padarray(binary,[1 1],'replicate');

    M = binary;
    image1 = image;
    P1 = image;

    [x,y]=size(image);


    for j=1:y    
        for i=1:x  
            if M(i,j)==0    
                if j-1>0 && i-1>0 && j+1<=y && i+1<=x     
                    if (M(i,j-1)+M(i,j+1)+M(i-1,j)+M(i+1,j))==0

                        P1(i,j) = image(i,j);
                        image1(i,j) = P1(i,j);

                    else
                        P1(i,j) = (image1(i-1,j)*M(i-1,j) + image1(i+1,j)*M(i+1,j) + image1(i,j+1)*M(i,j+1) + ...
                                  + image1(i,j-1)*M(i,j-1))/(M(i,j-1) + M(i,j+1) + M(i-1,j) + M(i+1,j));
                        image1(i,j) = P1(i,j);

                    end
                    M(i,j) = 1;
                end
            end
        end
    end


    M = binary;
    image2 = image;
    P2 = image1;

    for j=y:-1:1
        for i=1:x   
            if M(i,j)==0
                if j-1>0 && i-1>0 && j+1<=y && i+1<=x
                    if (M(i,j-1)+M(i,j+1)+M(i-1,j)+M(i+1,j))==0
                        P2(i,j) = image2(i,j);
                        image2(i,j) = P2(i,j);

                    else
                        P2(i,j) = (image2(i-1,j)*M(i-1,j)+image2(i+1,j)*M(i+1,j) + image2(i,j+1)*M(i,j+1) + image2(i,j-1)*M(i,j-1))/(M(i,j-1) + M(i,j+1) + M(i-1,j) +M(i+1,j));
                        image2(i,j) = P2(i,j);

                    end
                    M(i,j) = 1;
                end
            end
        end
    end


    M = binary;
    image3 = image;
    P3 = image2;

    for j=1:y
        for i=x:-1:1    
            if M(i,j)==0
                if j-1>0 && i-1>0 && j+1<=y && i+1<=x
                    if (M(i,j-1)+M(i,j+1)+M(i-1,j)+M(i+1,j))==0
                        P3(i,j) = image3(i,j);
                        image3(i,j) = P3(i,j);

                    else
                        P3(i,j) = (image3(i-1,j)*M(i-1,j) + image3(i+1,j)*M(i+1,j) + image3(i,j+1)*M(i,j+1) + image3(i,j-1)*M(i,j-1))/(M(i,j-1) + M(i,j+1) + M(i-1,j) + M(i+1,j));
                        image3(i,j) = P3(i,j);

                    end
                    M(i,j) = 1;
                end 
            end
        end
    end


    M = binary;
    image4 = image;
    P4 = image4;

    for j=y:-1:1
       for i=x:-1:1 
            if M(i,j)==0
                if j-1>0 && i-1>0 && j+1<=y && i+1<=x
                    if (M(i,j-1)+M(i,j+1)+M(i-1,j)+M(i+1,j))==0
                        P4(i,j) = image4(i,j);
                        image4(i,j) = P4(i,j);

                    else
                        P4(i,j)=(image4(i-1,j)*M(i-1,j) + image4(i+1,j)*M(i+1,j) + image4(i,j+1)*M(i,j+1) + image4(i,j-1)*M(i,j-1))/(M(i,j-1) + M(i,j+1) + M(i-1,j) + M(i+1,j));
                        image4(i,j) = P4(i,j);

                    end
                    M(i,j) = 1;
                end
            end
       end
    end


    P1_ = P1(2:x_gray+1,2:y_gray+1);
    P2_ = P2(2:x_gray+1,2:y_gray+1);
    P3_ = P3(2:x_gray+1,2:y_gray+1);
    P4_ = P4(2:x_gray+1,2:y_gray+1);

    background_min = zeros(x_gray,y_gray);
    background_avg = zeros(x_gray,y_gray);

    for i=1:x_gray
        for j=1:y_gray
            background_min(i,j) = min([P1_(i,j), P2_(i,j), P3_(i,j), P4_(i,j)]);
            background_avg(i,j)=(P1_(i,j)+ P2_(i,j)+ P3_(i,j)+ P4_(i,j))/4;
        end
    end



    background_min=uint8(background_min); background_avg=uint8(background_avg);
    %figure, imshow(background_min)
    %figure, imshow(background_avg)


      

  