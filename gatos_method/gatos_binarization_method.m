clc;  close all;

% read image
image = imread('4.jpg');
[r, c, z] = size(image);

if z> 1
    gray = rgb2gray(image);
else
    gray = image;
end
%figure,imshow(gray);

%apply wiener filter
gray_wiener=wiener2(gray, [3,3]);
%figure,imshow(gray_wiener);

% temp sauvola binary image
sauvola_bin=sauvola(gray_wiener,25,0.2);
%figure,imshow(sauvola_bin);

sauvola_bin = ~sauvola_bin;  % cause authors consider foreground pixel as 1


%%%first we have to calculate characters mean height and stroke width 

heigth=character_height(sauvola_bin); 
str_width=stroke_width(sauvola_bin); 


% background estimation
background=gatos_background_estimation(gray_wiener, sauvola_bin,heigth,str_width);
%figure, imshow(background);

%%final thresholding

final_binary=final_thresholding(gray,sauvola_bin,background);
%figure, imshow(~final_binary)


%%%post-processing
post_image = post_processing(final_binary,heigth);

post_image = ~post_image;
figure, imshow(post_image)
 





