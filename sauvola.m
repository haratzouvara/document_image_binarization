

%read image -- put image url
image = imread('image.jpg');

% convert image to grayscale
gray = rgb2gray(image);

% window
w=15;

% k value
k=0.4;

% convert to double
gray = double(gray);

% Mean value
filterWindow = ones(w,w) /(w*w);
mean = imfilter(gray, filterWindow, 'replicate' );

% Standard deviation
meanSquare = imfilter(gray.^2,filterWindow, 'replicate' );  
deviation = (meanSquare - mean.^2).^0.5;


R = max(deviation(:));
threshold = mean.*(1 + k * (deviation / R-1));
binary = (gray > threshold);

figure, imshow(binary);
