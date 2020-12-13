clc; clear all; close all;

%%define number of clusters and filter size
clust_color = 4; clust_gray = 5;  filter = 7;

%%apply clarity filter 
clar = [0 -1 0; -1 5 -1; 0 -1 0];

%%read images
%%color image
color_image = imread('autumn10.jpg');
color_image = double(color_image);
color_image = color_image/255;
figure, imshow(color_image);

%%gray image 
gray_image = imread('autumn11.jpg');
[x2,y2,z2] = size(gray_image);
gray_image = double(gray_image);
if z2>1
    gray_image = gray_image/255;
    gray_image = rgb2gray(gray_image);
   % figure, imshow(gray_image)
end

%%rgb2lab for color image
color_lab = rgb2lab(color_image);
l_color = color_lab(:,:,1);
l_color = double(l_color);

a_color = color_lab(:,:,2);
b_color = color_lab(:,:,3);
figure, imshow(uint8(l_color));

%normalization of gray image
gray_image = (gray_image - min(min(gray_image)))*(max(max(l_color)))/((max(max(gray_image))) - min(min(gray_image)));

%%scaling lab luminance  
color_mean = mean2(l_color);
color_std = std2(l_color);

gray_mean = mean2(gray_image);
gray_std = std2(gray_image);

l1_color_sc = (gray_std/color_std).*(l_color - color_mean) + gray_mean;
figure, imshow(uint8(l1_color_sc))

%%apply clarity filter
f_color_ = imfilter(l1_color_sc,clar,'replicate');
f_gray_ = imfilter(gray_image,clar,'replicate');

%%%%%statistical feature extraction
f_1_color = f_color_;
f_1_gray = f_gray_;

K = ones(filter,filter)/(filter*filter);
K(round(filter/2),round(filter/2)) = 0;

f_2_color = imfilter(f_color_,K,'replicate');
figure, imshow(uint8(f_2_color))

f_2_gray = imfilter(f_gray_,K,'replicate');
figure, imshow(uint8(f_2_gray))

icolor_temp_3 = padarray(f_color_,[filter filter],'replicate');
f_3_color = stdfilt(icolor_temp_3,round(K*((filter*filter))));
f_3_color = f_3_color(filter+1:end-filter,filter+1:end-filter);
figure, imshow(uint8(f_3_color))

igray_gia_3 = padarray(f_gray_,[filter filter],'replicate');
f_3_gray = stdfilt(igray_gia_3,round(K*((filter*filter))));
f_3_gray = f_3_gray(filter+1:end-filter,filter+1:end-filter);
figure, imshow(uint8(f_3_gray))

%%%%%texture feature extraction

%%define texture filters
E5 = [-1 -2 0 2 1];
W5 = [-1 2 0 -2 1];
S5 = [-1 0 2 0 -1];
L5 = [1 4 6 4 1];
R5 = [1 -4 6 -4 1];

E5S5 = E5'.*S5;
L5S5 = L5'.*S5;
E5L5 = E5'.*L5;
R5R5 = R5'.*R5;


%%aply filters
f_4_color = imfilter(f_color_,E5S5,'replicate');
figure, imshow(uint8(f_4_color))

f_4_gray = imfilter(f_gray_,E5S5,'replicate');
figure, imshow(uint8(f_4_gray))

f_5_color = imfilter(f_color_,L5S5,'replicate');
figure, imshow(uint8(f_5_color))

f_5_gray = imfilter(f_gray_,L5S5,'replicate');
figure, imshow(uint8(f_5_gray))

f_6_color = imfilter(f_color_,E5L5,'replicate');
figure, imshow(uint8(f_6_color))

f_6_gray = imfilter(f_gray_,E5L5,'replicate');
figure, imshow(uint8(f_6_gray))

f_7_color = imfilter(f_color_,R5R5,'replicate');
figure, imshow(uint8(f_7_color))

f_7_gray = imfilter(f_gray_,R5R5,'replicate');
figure, imshow(uint8(f_7_gray))


[n_color,c_color] = size(f_7_color);  [n_gray,c_gray] = size(f_7_gray);

%%%%define vectors 
f_1_color=f_1_color(:); f_2_color=f_2_color(:); f_3_color=f_3_color(:); f_4_color=f_4_color(:); f_5_color=f_5_color(:); f_6_color=f_6_color(:); f_7_color=f_7_color(:);
im_color_vector7(:,1) = f_1_color;
im_color_vector7(:,2) = f_2_color;
im_color_vector7(:,3) = f_3_color;
im_color_vector7(:,4) = f_4_color;
im_color_vector7(:,5) = f_5_color;
im_color_vector7(:,6) = f_6_color;
im_color_vector7(:,7) = f_7_color;

f_1_gray=f_1_gray(:); f_2_gray=f_2_gray(:); f_3_gray=f_3_gray(:); f_4_gray=f_4_gray(:); f_5_gray=f_5_gray(:); f_6_gray=f_6_gray(:); f_7_gray=f_7_gray(:);
im_gray_vector7(:,1) = f_1_gray;
im_gray_vector7(:,2) = f_2_gray;
im_gray_vector7(:,3) = f_3_gray;
im_gray_vector7(:,4) = f_4_gray;
im_gray_vector7(:,5) = f_5_gray;
im_gray_vector7(:,6) = f_6_gray;
im_gray_vector7(:,7) = f_7_gray;


%%%% vector normalization
im_color_vector7(:,1) = (im_color_vector7(:,1)-min(min(im_color_vector7(:,1))))*(1-(-1))/((max(max(im_color_vector7(:,1))))-min(min(im_color_vector7(:,1))))+(-1);
im_color_vector7(:,2) = (im_color_vector7(:,2)-min(min(im_color_vector7(:,2))))*(1-(-1))/((max(max(im_color_vector7(:,2))))-min(min(im_color_vector7(:,2))))+(-1);
im_color_vector7(:,3) = (im_color_vector7(:,3)-min(min(im_color_vector7(:,3))))*(1-(-1))/((max(max(im_color_vector7(:,3))))-min(min(im_color_vector7(:,3))))+(-1);
im_color_vector7(:,4) = (im_color_vector7(:,4)-min(min(im_color_vector7(:,4))))*(1-(-1))/((max(max(im_color_vector7(:,4))))-min(min(im_color_vector7(:,4))))+(-1);
im_color_vector7(:,5) = (im_color_vector7(:,5)-min(min(im_color_vector7(:,5))))*(1-(-1))/((max(max(im_color_vector7(:,5))))-min(min(im_color_vector7(:,5))))+(-1);
im_color_vector7(:,6) = (im_color_vector7(:,6)-min(min(im_color_vector7(:,6))))*(1-(-1))/((max(max(im_color_vector7(:,6))))-min(min(im_color_vector7(:,6))))+(-1);
im_color_vector7(:,7) = (im_color_vector7(:,7)-min(min(im_color_vector7(:,7))))*(1-(-1))/((max(max(im_color_vector7(:,7))))-min(min(im_color_vector7(:,7))))+(-1);

im_gray_vector7(:,1) = (im_gray_vector7(:,1)-min(min(im_gray_vector7(:,1))))*(1-(-1))/((max(max(im_gray_vector7(:,1))))-min(min(im_gray_vector7(:,1))))+(-1);
im_gray_vector7(:,2) = (im_gray_vector7(:,2)-min(min(im_gray_vector7(:,2))))*(1-(-1))/((max(max(im_gray_vector7(:,2))))-min(min(im_gray_vector7(:,2))))+(-1);
im_gray_vector7(:,3) = (im_gray_vector7(:,3)-min(min(im_gray_vector7(:,3))))*(1-(-1))/((max(max(im_gray_vector7(:,3))))-min(min(im_gray_vector7(:,3))))+(-1);
im_gray_vector7(:,4) = (im_gray_vector7(:,4)-min(min(im_gray_vector7(:,4))))*(1-(-1))/((max(max(im_gray_vector7(:,4))))-min(min(im_gray_vector7(:,4))))+(-1);
im_gray_vector7(:,5) = (im_gray_vector7(:,5)-min(min(im_gray_vector7(:,5))))*(1-(-1))/((max(max(im_gray_vector7(:,5))))-min(min(im_gray_vector7(:,5))))+(-1);
im_gray_vector7(:,6) = (im_gray_vector7(:,6)-min(min(im_gray_vector7(:,6))))*(1-(-1))/((max(max(im_gray_vector7(:,6))))-min(min(im_gray_vector7(:,6))))+(-1);
im_gray_vector7(:,7) = (im_gray_vector7(:,7)-min(min(im_gray_vector7(:,7))))*(1-(-1))/((max(max(im_gray_vector7(:,7))))-min(min(im_gray_vector7(:,7))))+(-1);


%%apply kmeans 
[cluster_color,w_color] = kmeans(im_color_vector7,clust_color,'MaxIter',1000);
color_cluster = reshape(cluster_color,n_color,c_color);
figure, imagesc((color_cluster))


[cluster_color,w_gray] = kmeans(im_gray_vector7,clust_gray,'MaxIter',1000);
gray_cluster = reshape(cluster_color,n_gray,c_gray);
figure, imagesc((gray_cluster))


%%forced cluster mapping
%%%%calculate the distance between centers

w_color=w_color'; w_gray=w_gray';
distance = zeros(clust_color, clust_gray);
for i= 1:clust_color   %%%% number of cluster --- color image
    for j= 1:clust_gray %%%% number of cluster --- grayscale image
        distance(i,j) = sqrt((w_color(1,i)-w_gray(1,j)).^2 + (w_color(2,i)-w_gray(2,j)).^2 + (w_color(3,i)-w_gray(3,j)).^2+(w_color(4,i)-w_gray(4,j)).^2+(w_color(5,i)-w_gray(5,j)).^2+(w_color(6,i)-w_gray(6,j)).^2+(w_color(7,i)-w_gray(7,j)).^2);
    end
end

%choose the bigger number of cluster to continue process
if clust_color>clust_gray
    big_clust = clust_color;
else
    big_clust = clust_gray;
end

combine = zeros(clust_gray,2);

for k =1:big_clust
   min_distance=10^3;
    for i =1:clust_color
        for j =1:clust_gray
            if distance(i,j)<min_distance
                min_distance = distance(i,j);
                cluster_1 = i;  %%%%color
                cluster_2 = j;  %%%%gray
                combine(k,1) = cluster_1;
                combine(k,2) = cluster_2;
            end
        end
    end
 distance(:,cluster_2) = 10^3;
end

%%%%%number of pixels for every cluster
sum_color = zeros(clust_color,1); sum_gray = zeros(clust_gray,1);
for i=1:n_color
    for j=1:c_color
        for d=1:clust_color
            if color_cluster(i,j)==d
                sum_color(d) = sum_color(d)+1;
            end
        end
    end
end
       

for i=1:n_gray
    for j=1:c_gray
        for d=1:clust_gray
            if gray_cluster(i,j)==d
                sum_gray(d) = sum_gray(d)+1;
            end
        end
    end
end


[order_combine, co_color] = sort(combine(:,1));
order_combine(:,2) = combine(co_color,2);

number_of_pixel = zeros(clust_gray,2);
for i=1:clust_gray
    number_of_pixel(i,1) = sum_color(order_combine(i,1));
    number_of_pixel(i,2) = sum_gray(order_combine(i,2));
end



color_cluster_v = color_cluster(:);
gray_cluster_v = gray_cluster(:);

%%%%%% calculate vectors distance from the center of clusters
distance_color = zeros(length(color_cluster_v),3);
for i = 1:length(color_cluster_v)
      intig = color_cluster_v(i);
      distance_color(i,1) = sqrt((w_color(1,intig)-im_color_vector7(i,1)).^2+(w_color(2,intig)-im_color_vector7(i,2)).^2+(w_color(3,intig)-im_color_vector7(i,3)).^2+(w_color(4,intig)-im_color_vector7(i,4)).^2+(w_color(5,intig)-im_color_vector7(i,5)).^2+(w_color(6,intig)-im_color_vector7(i,6)).^2+(w_color(7,intig)-im_color_vector7(i,7)).^2);
      distance_color(i,2) = intig;
      distance_color(i,3) = i;
end

distance_gray = zeros(length(gray_cluster_v),3);
for i=1:length(gray_cluster_v)
      intig_ = gray_cluster_v(i);
      intig1 = find(order_combine(:,2)==intig_);
      intig = order_combine(intig1,1);
      distance_gray(i,1) = sqrt((w_color(1,intig)-im_gray_vector7(i,1)).^2+(w_color(2,intig)-im_gray_vector7(i,2)).^2+(w_color(3,intig)-im_gray_vector7(i,3)).^2+(w_color(4,intig)-im_gray_vector7(i,4)).^2+(w_color(5,intig)-im_gray_vector7(i,5)).^2+(w_color(6,intig)-im_gray_vector7(i,6)).^2+(w_color(7,intig)-im_gray_vector7(i,7)).^2);
      distance_gray(i,2) = intig_;
      distance_gray(i,3) = i;
end

%%%%%order distances
[order_distance_color, co_color] = sort(distance_color(:,1));
[order_distance_gray, co_gray] = sort(distance_gray(:,1));

%%%%column 2-- cluster , column 3-- pixel position
for i=1:length(order_distance_color)
    order_distance_color(i,2)=distance_color(co_color(i),2);
    order_distance_color(i,3)=distance_color(co_color(i),3);
end

for i=1:length(order_distance_gray)
    order_distance_gray(i,2)=distance_gray(co_gray(i),2);
    order_distance_gray(i,3)=distance_gray(co_gray(i),3);
end


%%%%%separate pixels depend on cluster
for count_cluster =1:clust_color
    k = 0;
    for i =1:length(order_distance_color)
        if order_distance_color(i,2)==count_cluster
            k = k + 1;
            sep_order_distance_color(k,1,count_cluster) = order_distance_color(i,1);
            sep_order_distance_color(k,2,count_cluster) = order_distance_color(i,3);
       end
   end
end
  
  
for count_cluster =1:clust_gray
    k = 0;
    for i=1:length(order_distance_gray)  
        if order_distance_gray(i,2)==count_cluster  
            k = k + 1;
           sep_order_distance_gray(k,1,count_cluster) = order_distance_gray(i,1);
           sep_order_distance_gray(k,2,count_cluster) = order_distance_gray(i,3);
        end
    end
end

%%define a and b for colorized image
a_color = a_color(:);
b_color = b_color(:);
a_new = zeros(n_gray*c_gray,1);
b_new = zeros(n_gray*c_gray,1);

for i = 1:length(number_of_pixel(:,1))
    if number_of_pixel(i,1)>number_of_pixel(i,2)
        first = sep_order_distance_color(1:number_of_pixel(i,1),2,order_combine(i,1));
        temp_matrix = imresize(first,[number_of_pixel(i,2) 1],'nearest');
        temp_matrix = round(temp_matrix);

        for count =1:number_of_pixel(i,2)
            a_new(sep_order_distance_gray(count,2,order_combine(i,2))) = a_color(temp_matrix(count));
            b_new(sep_order_distance_gray(count,2,order_combine(i,2))) = b_color(temp_matrix(count));
        end
    end
end
      

for i =1:length(number_of_pixel(:,1))
    if number_of_pixel(i,1)<=number_of_pixel(i,2)
        z = 0;
        while z<number_of_pixel(i,2)
             for k =1:number_of_pixel(i,1)
                 if z==number_of_pixel(i,2)
                    break;
                 end
             z = z + 1;
             temp_matrix(z,1) = sep_order_distance_color(k,1,order_combine(i,1));
             temp_matrix(z,2) = sep_order_distance_color(k,2,order_combine(i,1));
      
            end
        end 
  
        for count = 1:number_of_pixel(i,2)
            a_new(sep_order_distance_gray(count,2,order_combine(i,2))) = a_color(temp_matrix(count,2));
            b_new(sep_order_distance_gray(count,2,order_combine(i,2))) = b_color(temp_matrix(count,2));
        end
   end
end



a_final = reshape(a_new,n_gray,c_gray);
b_final = reshape(b_new,n_gray,c_gray);
l_final = gray_image;
figure, imshow(uint8(l_final))

%%convert lab2rgb
final_lab(:,:,1) = l_final;
final_lab(:,:,2) = a_final;
final_lab(:,:,3) = b_final;
final_color_image = lab2rgb(final_lab);
figure, imshow(final_color_image)

