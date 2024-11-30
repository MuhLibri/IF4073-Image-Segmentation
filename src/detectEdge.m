function img = detectEdge(image, type, threshold, sigma)
    if (nargin < 3)
        threshold = [];
        sigma = 0;
    end
    
    % Convert to gray if image is RGB    
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    
    % Apply gaussian filter to the image only if sigma > 0 and operator not Canny or LoG    
    if sigma > 0 && type ~= "Canny" && type ~= "LoG"
        image = imgaussfilt(image, sigma);
    end
    
    switch type
        case "Laplace"
            H = [1 1 1; 1 -8  1; 1  1  1];
            img = imbinarize(uint8(conv2(double(image), double(H), 'same')));
        case "LoG"
            H = fspecial('log', 5, sigma);
            img = imbinarize(uint8(conv2(double(image), double(H), 'same')));            
        case "Sobel"
            Sx = [-1 0 1; -2 0 2; -1 0 1];
            Sy = [1 2 1; 0 0 0; -1 -2 -1];
            Jx = conv2(double(image), double(Sx), 'same');
            Jy = conv2(double(image), double(Sy), 'same');
            img = imbinarize(uint8(sqrt(Jx.^2 + Jy.^2)));
        case "Prewitt"
            Px = [-1 0 1; -1 0 1; -1 0 1];
            Py = [-1 -1 -1; 0 0 0; 1 1 1];
            Jx = conv2(double(image), double(Px), 'same');
            Jy = conv2(double(image), double(Py), 'same');
            img = imbinarize(uint8(sqrt(Jx.^2 + Jy.^2)));
        case "Roberts"
            Rx = [1 0; 0 -1];
            Ry = [0 1; -1 0];
            Jx = conv2(double(image), double(Rx), 'same');
            Jy = conv2(double(image), double(Ry), 'same');
            img = imbinarize(uint8(sqrt(Jx.^2 + Jy.^2)));
        case "Canny"
            img = edge(image, "Canny", threshold, sigma);
    end

    % Set the outermost pixel to 0            
    img([1, end], :) = 0;
    img(:, [1, end]) = 0;
end