clc; clear all; close all;

%read image
image = imread('92.jpg');
%figure, imshow(image),title('image');
[x,y,z] = size(image);

%convert image to grayscale
if z>1
    gray = rgb2gray(image);
else
    gray = image;
end
%figure, imshow(gray),title('grayscale image');

% apply temp niblack binarization method
%best 25 -0.7
niblack_bin = niblack(gray,25,-0.7);
%figure, imshow(niblack_bin),title('niblack binary image');

% apply dilation to niblack binary image
SE = strel('square',3);   %dilation  3x3 window
niblack_bin = imdilate(~niblack_bin,SE);
%figure, imshow(niblack_bin), title('niblack dilated image');


% background estimation
[background, background_avg] = back_estim_ntirogiannis(gray,~niblack_bin);
%figure, imshow(background), title('background estimation');

% normalization grayscale image
normal_gray = normalization(gray,background);
%figure, imshow(normal_gray),title('normalized image');

% calculate otcu binary image
otsu_binary = otsu(normal_gray);
%figure, imshow(otsu_binary),title('otsu binary image');

%post_processing to otsu binary result
enhanced_otsu = enhance_otsu(otsu_binary);
%figure, imshow(enhanced_otsu),title('post-processed otsu binary image')

%calculate contrast and k_value for next niblack apply
[C, k_niblack] = contrast_kniblack(gray, background_avg, enhanced_otsu);

% calculate  stroke width
str_width = stroke_width(~otsu_binary);

%new niblack image from normalized gray image
niblack_normal = niblack(normal_gray,2*str_width, k_niblack);
%figure, imshow((niblack_normal)), ('niblack norm image');


% find common regions between new niblack image and enhanced otsu result
[final_niblack] = find_common_regions(niblack_normal, enhanced_otsu, C);
%figure, imshow (Niblack_conn2), title('niblack-otsu image');

% final post-processing 
final_binary_image = ntiro_post_processing(final_niblack, otsu_binary);
figure, imshow(final_binary_image),title('final binary image');
            

        