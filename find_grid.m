function [ angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing ] = find_grid( image )

% Find connected components
cc = bwconncomp(image < 100, 8);

% Take bounding boxes
boxes = regionprops(cc, 'BoundingBox');

points = zeros(size(boxes, 1), 2);

for i = 1:size(boxes, 1)
    area = boxes(i).BoundingBox(3) * boxes(i).BoundingBox(4);
    center = [boxes(i).BoundingBox(1) + boxes(i).BoundingBox(3) / 2, boxes(i).BoundingBox(2) + boxes(i).BoundingBox(4) / 2];
    
    % Take their centroids
    points(i, :) = center;
end

points = repmat(points, 1, 1, size(boxes, 1));

points_temp = permute(points, [3 2 1]);

% Find distances to nearest four neighbors
distances = (points - points_temp);

% Find angles to nearest four neighbors
angles = permute(atan2(distances(:, 2, :), distances(:, 1, :)), [1 3 2]);

distances = permute(sqrt(sum(distances .^ 2, 2)), [1 3 2]);
[distances, indices] = sort(distances, 2);

distances = distances(:, 2:5);
angles = angles(:, indices);
angles = angles(:, 2:5);

scatter(distances(:), angles(:));

% Perform k-means on distance + angle pairs with 2 means

end