%read image -- put image path
image = imread('143.png');

% convert image to grayscale
gray = rgb2gray(image);

% window
w=25;

% convert to double
gray = double(gray);

% Mean value   %% averagefilter is provided by matlab  
mean = averagefilter(gray,[w w],'replicate');

%Standar deviation
meanSquare = averagefilter(gray.^2,[w w], 'replicate');  
deviation    = (meanSquare-mean.^2).^0.5;

%k value
k_value = -0.5;

binary = zeros(size(gray));
binary(gray > mean + k *deviation) = 1;

figure, imshow(binary);


