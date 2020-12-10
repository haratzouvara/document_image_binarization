function post_image = post_processing(post_image,heigth)


n = 0.15*heigth; 
n = floor(n);

ksw = 0.6*n^2; % value ksw is not the suggest value
ksh = 0.9*n^2;
%dx=0.25*n; dy=dx;
ksw1 = 0.6*n^2;
kernel = ones(n,n);

%%% shrink filter


Psh_ = conv2(1-post_image, kernel, 'same');
Psh = post_image.*Psh_;

post_image(Psh>ksh) = 0;
%figure,imshow(~fin_binary);

%%% swell filter  ---missing xa, ya conditions

Psw_ = conv2(post_image, kernel, 'same');
Psw = (1-post_image).*Psw_;

post_image(Psw>ksw) = 1;
%figure,imshow(~fin_binary);

%%% third filter

Psw1_ = conv2(post_image, kernel, 'same');
Psw1 = (1-post_image).*Psw1_;

post_image(Psw1>ksw1) = 1;
%figure,imshow(~fin_binary);

