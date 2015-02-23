function [ letters ] = find_letters( image, grid_points, horizontal_spacing, vertical_spacing, angle )
    original = image;
    
    % Unrotate the image, for OCR
    image = 1 - image;
    image = imrotate(image, 180 * angle / pi);
    image = 1 - image;
    
    % Keep track of results for each orientation
    result = cell(4, 1);
    confidence = zeros(1, 4);
    
    % Try OCR on each orientation
    for i = 1:4
        image = imrotate(image, 90);
        result{i} = ocr(image, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
        
        confidences = result{i}.CharacterConfidences;
        confidences(isnan(confidences)) = 0;
        
        confidence(i) = sum(confidences);
    end
    
    % Sort results by the total confidence and pick the best one
    [~, indices] = sort(confidence, 'descend');
    best_result = result{indices(1)};
    rotation = pi / 2 * indices(1);
    
    % Shift the bounding box locations from upper-left corners to centers
    centers = best_result.CharacterBoundingBoxes(:, 1:2);
    centers(:, 1) = centers(:, 1) + best_result.CharacterBoundingBoxes(:, 3) ./ 2;
    centers(:, 2) = centers(:, 2) + best_result.CharacterBoundingBoxes(:, 4) ./ 2;
    
    % Re-rotate the bounding box centers to the original angle
    centers = centers - repmat(size(image) ./ 2, size(centers, 1), 1);
    centers = centers * [cos(-angle - rotation), -sin(-angle - rotation); sin(-angle - rotation), cos(-angle - rotation)];
    centers = centers + repmat(size(original) ./ 2, size(centers, 1), 1);
    
    % Remove all the spaces and newlines
    nonBlank = find(1 - isnan(best_result.CharacterConfidences));
    
    letterList = cell(size(nonBlank));
    letterCenters = zeros(size(nonBlank, 1), 2);
    
    letters = char(zeros(size(grid_points, 1), size(grid_points, 2)));
    
    for i = 1:size(nonBlank, 1)
        letterList{i} = best_result.Text(nonBlank(i));
        letterCenters(i, :) = centers(nonBlank(i), :);
    end
    
    nominalDistance = min(horizontal_spacing, vertical_spacing) / 2;
    
    for i = 1:size(grid_points, 1)
        for j = 1:size(grid_points, 2)
            letters(i, j) = '^';
            
            point = repmat(permute(grid_points(i, j, :), [1 3 2]), size(nonBlank, 1), 1);
            
            distances = sum((point - letterCenters) .^ 2, 2);
            [distance, nearest] = min(distances, [], 1);
            
            if distance < nominalDistance
                letters(i, j) = letterList{nearest};
            end
        end
    end
    
%     imshow(original);
%     viscircles(letterCenters, repmat([10], size(letterCenters, 1), 1), 'LineWidth', 1, 'EdgeColor', 'r');
end

