function normal_image = normalization(gray, background)
    
    gray = double(gray);
    background = double(background);
    
    image_max = max(max(gray));
    image_min = min(min(gray));
    
    F = (gray + 1)./(background + 1);
    F_max = max(max(F));
    F_min = min(min(F));
    
    normal_image = (image_max - image_min)*((F - F_min)./(F_max - F_min)) + image_min;
    normal_image = uint8(normal_image);
   