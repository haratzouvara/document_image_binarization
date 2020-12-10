function avg_height = character_height(image)

    [r,~] = size(image);
   
    [image_label,~] = bwlabel(image,8);
    regions = regionprops(image_label, 'BoundingBox');
    
    bound_box = {regions.BoundingBox};
    BOX = cell2mat(bound_box);
    heights = BOX(4:4:length(BOX));
    
    heights(heights<=10 | heights>=r/2) = [];
    avg_height = round(sum(heights)/length(heights));

