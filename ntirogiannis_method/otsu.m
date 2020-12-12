function Bw=otsu(Im)

	[m,n] = size(Im);
	imsize = m*n;
	[x,y] = imhist(Im);

	p = x/imsize;

	for k =1:256
	    
	    c0(1:k) = p(1:k); 
	    c1(k+1:256) = p(k+1:256);
	    w0 = sum(c0);
	
	    if w0>0
		w1=1-w0;
		if w1>0
		    m0 = 0;
		
		    for i =1:k
			m0 = m0 + i*p(i);
		    end
		    
		    m0 = m0/w0;
		    m1 = 0;
		   
		    for i =k+ 1:256
			m1 = m1 + i*p(i);
		    end
		    
		    m1 = m1/w1;
		    sb(k) = w0*w1*(m1 - m0)*(m1 - m0);
		    
		end
	    end
	end
		    
	[peak,Threshold] = max(sb);
		    
	for i=0:255
	    y(i+1) = i;
	end
	
	x1(1) = Threshold;
	y1(1) = 0;
	x1(2) = Threshold;
	y1(2) = peak;

	Threshold = Threshold/256;
	Bw = im2bw(Im,Threshold);
       



    
    
    
