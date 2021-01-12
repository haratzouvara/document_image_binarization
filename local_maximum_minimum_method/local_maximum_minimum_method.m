clc; clear all; close all;

%read image
image = imread('92.jpg');
%figure, imshow(image);

[x,y,z]=size(image);

if z > 1
    gray = rgb2gray(image);
else
    gray = image;
end



%define window size
w = 3;
w_ = floor(w/2);

%calculate contrast map
contrast = contrast_map(gray, w_);

%apply otsu method to contrast map
otsu_contrast = otsu(contrast);
%figure, imshow(otsu_contrast)


%calculate stroke width
sw =stroke_width(otsu_contrast);


final_binary = final_thresholding_contrast(gray, ~otsu_contrast, sw);
figure, imshow(final_binary);   
 


