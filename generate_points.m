function [ points ] = generate_points( width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing )

rect = [0 0 1; width 0 1; 0 height 1; width height 1];
transform = [cos(-angle) sin(-angle) 0; -sin(-angle) cos(-angle) 0; 0 0 1];
inv_transform = [cos(angle) sin(angle) 0; -sin(angle) cos(angle) 0; 0 0 1];

new_rect = rect * transform;
mins = min(new_rect, [], 1);
maxs = max(new_rect, [], 1);

bounding_rect = [mins(1) mins(2); mins(1) maxs(2); maxs(1) mins(2); maxs(1) maxs(2)];
bounding_size = bounding_rect(4, :) - bounding_rect(1, :);

grid_points = zeros(ceil(bounding_size(2) / vertical_spacing), ceil(bounding_size(1) / horizontal_spacing), 3);

for i = 1:size(grid_points, 1)
    for j = 1:size(grid_points, 2)
        grid_points(i, j, :) = [[j * horizontal_spacing - horizontal_offset, i * vertical_spacing - vertical_offset] + bounding_rect(1, :), 1] * inv_transform;
    end
end

points = grid_points(:, :, 1:2);

end