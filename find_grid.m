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

distances = distances(:, 2:4);
newang = zeros(size(angles));
for i = 1:size(angles,1)
    newang(i,:) = angles(i, indices(i,:));
end
angles = newang(:, 2:4);

[x, y] = pol2cart(angles(:), distances(:));

% hold on;
% scatter(x(:), y(:));


offsets = [x(:) y(:)];

[index, centers] = kmeans(offsets, 2,'Start','cluster');
[theta, rho] = cart2pol(centers(:, 1), centers(:, 2));

% viscircles(centers, [2; 2]);

pointsModX = initialPoints * [cos(-theta(1)) -sin(-theta(1)); sin(-theta(1)) cos(-theta(1))];
pointsModY = initialPoints * [cos(-theta(2)) -sin(-theta(2)); sin(-theta(2)) cos(-theta(2))];

centers

offsetX = median(mod(pointsModX(:, 1), rho(1)))
offsetY = median(mod(pointsModY(:, 1), rho(2)))

imshow(image);

circles = zeros(40 * 40, 2);

for i=1:40
    for j=1:40
        x = centers(1, :) .* (i - 19) + centers(1, :) ./ norm(centers(1, :)) .* offsetX;
        y = centers(2, :) .* (j - 19) + centers(2, :) ./ norm(centers(2, :)) .* offsetY;
        
        circles((i - 1) * 40 + j, :) = x + y;
    end
end

viscircles(circles, repmat([10], 40 * 40, 1), 'LineWidth', 1);

%When we find the angle, we should rotate the image, then find the offsets

%Offset should be the upperleft corner of a character in the grid
%How do we tell the number of characters horz and vert?

end