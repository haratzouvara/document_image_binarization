function binary = niblack(gray,w,k_value)


    % convert to double
    gray = double(gray);

    % mean value   
    filterWindow = ones(w,w) /(w*w);
    mean = imfilter(gray, filterWindow, 'replicate' );
    %mean = averagefilter(gray,[w w],'replicate');

    %Standar deviation
    meanSquare = imfilter(gray.^2,filterWindow, 'replicate' ) ;  
    deviation = (meanSquare-mean.^2).^0.5;


    [r,c] = size(gray);
    binary = zeros(size(gray));
    binary(gray > mean + k_value *deviation) = 1;
    %figure, imshow(binary);


