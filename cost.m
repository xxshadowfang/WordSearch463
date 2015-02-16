function [ dist ] = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing)

grid_points = generate_points(width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing);

grid_point_x = grid_points(:, :, 1);
grid_point_y = grid_points(:, :, 2);
grid = [grid_point_x(:), grid_point_y(:)];

points = repmat(points, 1, 1, size(grid, 1));
grid = repmat(grid, 1, 1, size(points, 1));
distances = sqrt(permute(sum((permute(grid, [3 2 1]) - points) .^ 2, 2), [1 3 2]));
nearest = min(distances, [], 2);
dist = median(nearest);

end