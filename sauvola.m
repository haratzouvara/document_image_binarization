
%read image -- put image url
image = imread('15.jpg');

% convert image to grayscale
gray = rgb2gray(image);

% window
w=15;

% convert to double
gray = double(gray);

% Mean value   %% averagefilter is provided by matlab  
mean = averagefilter(gray,[w w],'replicate');

% Standard deviation
meanSquare = averagefilter(gray.^2,[w w], 'replicate');
deviation = (meanSquare - mean.^2).^0.5;

% k value
k=0.4;

R = max(deviation(:));
threshold = mean.*(1 + k * (deviation / R-1));
binary = (gray > threshold);

figure, imshow(binary);
