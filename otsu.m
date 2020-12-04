%read image -- put image path
image = imread('143.png');

% convert image to grayscale
gray = rgb2gray(image);

[m,n]= size(gray);
pixels= m*n;

% image histogram
[x,y]= imhist(gray);


p= x/pixels;

for k = 1:256
    
    c0(1:k) = p(1:k); % background class
    c1(k+1:256) = p(k+1:256); % foreground class
    w0 = sum(c0);
    
    if w0 > 0
        w1 = 1 - w0;
        
        if w1 > 0
            m0 = 0;
            
            for i = 1:k
                m0 = m0 + i*p(i);
            end
            
            m0 = m0/w0;
            m1 = 0;
           
            for i= k+ 1:256
                m1 = m1 + i*p(i);
            end
            
            m1 = m1/w1;
        
            sb(k) = w0*w1*(m1 - m0)*(m1 - m0);
            
        end
    end
end
    
[peak,thresh]=max(sb);

for i = 0:255
    y(i+1) = i;
end

x1(1) = thresh;
y1(1) = 0;
x1(2) = thresh;
y1(2) = peak;

thresh = thresh/256;
binary = im2bw(gray,thresh);

figure, imshow(binary);



    
    
    
