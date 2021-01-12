%read image -- put image path
image = imread('image.jpg');

% convert image to grayscale
gray = rgb2gray(image);

% window
w=25;

%k value
k_value = -0.5;

% convert to double
gray = double(gray);


% mean value   
filterWindow = ones(w,w) /(w*w);
mean = imfilter(gray, filterWindow, 'replicate' );
    
%Standar deviation
meanSquare = imfilter(gray.^2,filterWindow, 'replicate' ) ;  
deviation = (meanSquare-mean.^2).^0.5;


binary = zeros(size(gray));
binary(gray > mean + k_value *deviation) = 1;

figure, imshow(binary);

