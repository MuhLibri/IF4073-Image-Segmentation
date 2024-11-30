function segmented_img = segmentation(image, type, radius, threshold, sigma)
    if nargin < 4
        threshold = [];
        sigma = 1;
    end

    % Perform edge detection
    edge_img = detectEdge(image, type, threshold, sigma);

    % Perform edge linking (Closing the gap in the edges)
    se = strel('disk', radius);
    closed_edges = imclose(edge_img, se);
    
    %  Filling the closed area   
    mask = imfill(closed_edges, 'holes');
    
    % Apply mask to the image to get segmented image
    if size(image, 3) == 3
        red_processed = image(:,:,1).*uint8(mask);
        green_processed = image(:,:,2).*uint8(mask);
        blue_processed = image(:,:,3).*uint8(mask);
        % Unite all RGB channel    
        segmented_img = cat(3,red_processed,green_processed,blue_processed);
    else
        segmented_img = image.*uint8(mask);
    end
end