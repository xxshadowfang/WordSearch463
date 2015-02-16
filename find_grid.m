function [ angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing ] = find_grid( image )

% Find connected components
cc = bwconncomp(1-image, 8);

% Take bounding boxes
boxes = regionprops(cc, 'BoundingBox');

initialPoints = zeros(size(boxes, 1), 2);

for i = 1:size(boxes, 1)
    area = boxes(i).BoundingBox(3) * boxes(i).BoundingBox(4);
    center = [boxes(i).BoundingBox(1) + boxes(i).BoundingBox(3) / 2, boxes(i).BoundingBox(2) + boxes(i).BoundingBox(4) / 2];

    % Take their centroids
    initialPoints(i, :) = center;
end

points = repmat(initialPoints, 1, 1, size(boxes, 1));

points_temp = permute(points, [3 2 1]);

% Find distances to nearest four neighbors
distances = (points - points_temp);

% Find angles to nearest four neighbors
angles = permute(mod(atan2(distances(:, 2, :), distances(:, 1, :)),pi), [1 3 2]);

distances = permute(sqrt(sum(distances .^ 2, 2)), [1 3 2]);
[distances, indices] = sort(distances, 2);

distances = distances(:, 2:5);
newang = zeros(size(angles));
for i = 1:size(angles,1)
    newang(i,:) = angles(i, indices(i,:));
end
angles = newang(:, 2:5);

[x, y] = pol2cart(angles(:), distances(:));

% hold on;
figure;
scatter(x(:), y(:));

offsets = [x(:) y(:)];

[index, centers] = kmeans(offsets, 2, 'distance', 'cityblock', 'start', 'cluster');
centers = sortrows(centers, 1);

[theta, rho] = cart2pol(centers(:, 1), centers(:, 2));


viscircles(centers, ones(1, size(centers, 1)) .* 2);

pointsModY = initialPoints * [cos(-theta(2)) -sin(-theta(2)); sin(-theta(2)) cos(-theta(2))];
pointsModX = initialPoints * [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))];

horizontal_offset = median(mod(pointsModX(:, 1), rho(1)));
vertical_offset = median(mod(pointsModY(:, 1), rho(2)));

horizontal_spacing = rho(1);
vertical_spacing = rho(2);

angle = theta(1);

figure;
imshow(image);

grid_points = generate_points(size(image, 2), size(image, 1), angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing);

grid_point_x = grid_points(:, :, 1);
grid_point_y = grid_points(:, :, 2);
grid = [grid_point_x(:), grid_point_y(:)];

% viscircles(grid, repmat([10], size(grid, 1), 1), 'LineWidth', 1, 'EdgeColor', 'b');

[angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing] = gradient_descent(initialPoints, size(image, 2), size(image, 1), angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing);

grid_points = generate_points(size(image, 2), size(image, 1), angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing);

grid_point_x = grid_points(:, :, 1);
grid_point_y = grid_points(:, :, 2);
grid = [grid_point_x(:), grid_point_y(:)];

viscircles(grid, repmat([10], size(grid, 1), 1), 'LineWidth', 1, 'EdgeColor', 'r');

end