function output=sauvola(image,w,k)


% Convert to double
image = double(image);

% Mean value
filterWindow = ones(w,w) /(w*w);
mean = imfilter(image, filterWindow, 'replicate' );

% Standard deviation
meanSquare = imfilter(image.^2,filterWindow, 'replicate' );  
deviation = (meanSquare - mean.^2).^0.5;

R = max(deviation(:));
threshold = mean.*(1 + k * (deviation / R-1));
output = (image > threshold);
%figure,imshow(output)
