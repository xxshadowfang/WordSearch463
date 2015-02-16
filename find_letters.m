function [ letters ] = find_letters( image, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing, height, width )
    ims = size(image); %should be 2D
    vert = floor( ims(1) / vertical_spacing );
    hor = floor( ims(2) / horizontal_spacing );
    letters = zeros(vert, hor);
    cc = bwconncomp(1-image, 8);
    boxes = regionprops(cc, 'BoundingBox');
    centroids = zeros(length(boxes),2);
    for i = 1:length(boxes)
        centroids(i,:) = [boxes(i).BoundingBox(1) + boxes(i).BoundingBox(3) / 2, boxes(i).BoundingBox(2) + boxes(i).BoundingBox(4) / 2];
    end
    for i = 1:vert
        for j = 1:hor
            gridpoint = [1,1];
end

