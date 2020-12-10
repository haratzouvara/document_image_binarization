function final_binary=final_thresholding(gray,binary,background)

[x,y]=size(binary);
gray=double(gray);
background=double(background);

%calculate d parameter
delta_1 = sum(sum(background - gray));
delta_2 = sum(sum(binary));
delta = delta_1./delta_2;

%calculate b parameter
b_1 = sum(sum(background - (1 - binary)));
b_2 = sum(sum(1 - binary));
b = b_1./b_2;

%b=floor(b);       
%d=floor(d);

p1 = 0.5; p2 = 0.8; q = 0.6;

%calculate d
 
d_ = 1 + exp((-4*background./(b*(1 - p1))) + (2*(1 + p1)./(1 - p1)));
 
d=q*delta*((1 - p2)./d_ + p2);
%d=floor(d);


final_binary = zeros(x,y);
final_binary(d < (background - gray)) = 1;
 