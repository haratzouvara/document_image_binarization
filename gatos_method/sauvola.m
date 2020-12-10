function output=sauvola(image,w,k)


% Convert to double
image = double(image);

% Mean value
mean = averagefilter(image,[w w],'replicate');

% Standard deviation
meanSquare = averagefilter(image.^2,[w w], 'replicate');
deviation = (meanSquare - mean.^2).^0.5;

R = max(deviation(:));
threshold = mean.*(1 + k * (deviation / R-1));
output = (image > threshold);
%figure,imshow(output)
