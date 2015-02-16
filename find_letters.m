function [ letters ] = find_letters( image, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing )
    ims = size(image); %should be 2D
    vert = floor( ims(1) / vertical_spacing );
    hor = floor( ims(2) / horizontal_spacing );
    hletters = char(zeros(vert, hor));
    cc = bwconncomp(1-image, 8);
    boxes = regionprops(cc, 'BoundingBox');
    centroids = zeros(length(boxes),2);
    for i = 1:length(boxes)
        centroids(i,:) = [boxes(i).BoundingBox(1) + boxes(i).BoundingBox(3) / 2, boxes(i).BoundingBox(2) + boxes(i).BoundingBox(4) / 2];
    end
    for i = 1:vert
        for j = 1:hor
            a = pol2cart(angle+(pi/2),vertical_spacing);
            b = pol2cart(angle,horizontal_spacing);
            gridpoint = [a .* i - a ./ vertical_spacing .* vertical_offset, b .* j - b ./ horizontal_spacing .* horizontal_offset];
            distances = zeros(size(centroids,1),1);
            for k = 1:length(distances)
                distances(k) = sqrt(sum(gridpoint-centroids(k,:).^2));
            end
            [sortdist, ind] = sort(distances);
            if sortdist(1) < 1.5*min(horizontal_spacing,vertical_spacing)
                r = ocr(image(floor(boxes(ind(1)).BoundingBox(1)):floor(boxes(ind(1)).BoundingBox(1) + boxes(ind(1)).BoundingBox(3)),floor(boxes(ind(1)).BoundingBox(2)):floor(boxes(ind(1)).BoundingBox(2) + boxes(ind(1)).BoundingBox(4))));
                if numel(r.Text) == 0;
                    hletters(i,j) = '^';
                else
                    hletters(i,j) = r.Text(1);
                end
            else
                hletters(i,j) = '^';
            end
        end
    end
    letters = hletters;
end

