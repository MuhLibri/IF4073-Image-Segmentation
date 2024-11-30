function img = houghTransformation(originalImage, edgeImage)
    [rows, cols] = size(edgeImage);

    % Masking
    mask = zeros(rows, cols);
    mask(floor(0.5*rows)+1:end, :) = 1;
    edgeImage = edgeImage .* cast(mask, 'like', edgeImage);
    %figure; imshow(edgeImage); title("Masked");
    
    theta = -75:0.25:75;
    theta_rad = deg2rad(theta); 

    diag_len = ceil(sqrt(rows^2 + cols^2));
    rho = -diag_len:1:diag_len;
    
    H = zeros(length(rho), length(theta)); 
    [edge_y, edge_x] = find(edgeImage);
    
    for i = 1:length(edge_x)
        x = edge_x(i);
        y = edge_y(i);
        
        for t = 1:length(theta)
            r = x * cos(theta_rad(t)) + y * sin(theta_rad(t));

            rho_index = floor(r) + diag_len + 1;
            H(rho_index, t) = H(rho_index, t) + 1;
        end
    end
    
    peaks = houghpeaks(H, 6, 'Threshold', ceil(0.3 * max(H(:))));
    lines = houghlines(edgeImage, theta, rho, peaks, 'FillGap', 40, 'MinLength', 70);

    %figure;
    %hold on;
    
    img = originalImage;
    % Overlay Detected Lines on the Image
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        
        %{
        % Plot the line in red
        plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'red');
        

        % Mark the start and end points of the line
        plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'green');
        plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'blue');
        %}

        img = insertShape(img,"line", xy, 'ShapeColor', 'red', 'LineWidth', 5);
    end

    %hold off;
end
