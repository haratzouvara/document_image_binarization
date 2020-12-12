function [post_processing_image] = ntiro_post_processing(co, binary)

    [x,y] = size(co);
    padding_co = padarray(co,[1 1],0, 'both');
    [x_,y_] = size(padding_co);
    
    f = zeros(x_,y_);
    for i=2:x_-1
        for j=2:y_-1
            if  padding_co(i+1,j)==0 || padding_co(i+1,j+1)==0 || padding_co(i-1,j)==0 || padding_co(i-1,j+1)==0 || padding_co(i-1,j-1)==0 || padding_co(i+1,j-1)==0 || padding_co(i,j+1)==0 || padding_co(i,j-1)==0 
                f(i,j)=0;
            else
                f(i,j)=1;
            end
        end
    end
    
    f_ = f(2:x_-1 ,2:y_-1);
    post_processing_image = co;
    post_processing_image = co| (binary.*f_);

