function [ letters, bounding_boxes ] = find_letters( image, grid_points, horizontal_spacing, vertical_spacing, angle )
    gps = size(grid_points);
    hletters = char(zeros(gps(1), gps(2)));
    cc = bwconncomp(1-image, 8);
    boxes = regionprops(cc, 'BoundingBox');
    centroids = zeros(length(boxes),2);
    for i = 1:length(boxes)
        centroids(i,:) = [boxes(i).BoundingBox(2) + boxes(i).BoundingBox(4) / 2, boxes(i).BoundingBox(1) + boxes(i).BoundingBox(3) / 2];
    end
    for i = 1:gps(1)
        for j = 1:gps(2)
            gp = grid_points(i,j,:);
            distances = zeros(size(centroids,1),1);
            for k = 1:length(distances)
                dowut = centroids(k,:);
                distances(k) = sqrt(sum((gp(:)-dowut(:)).^2));
            end
            [sortdist, ind] = sort(distances);
            if sortdist(1) < 0.75*min(horizontal_spacing,vertical_spacing)
                let = ones(31 + boxes(ind(1)).BoundingBox(4), 31 + boxes(ind(1)).BoundingBox(3));
                let(16:16+boxes(ind(1)).BoundingBox(4),15:15+boxes(ind(1)).BoundingBox(3)) = image(floor(boxes(ind(1)).BoundingBox(2)):floor(boxes(ind(1)).BoundingBox(2) + boxes(ind(1)).BoundingBox(4)), floor(boxes(ind(1)).BoundingBox(1)):floor(boxes(ind(1)).BoundingBox(1) + boxes(ind(1)).BoundingBox(3)));
                %let = imrotate(let,180*angle/pi,'crop');
                %imtool(let);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
                if numel(r.Text) == 0;
                    hletters(i,j) = '^';
                else
                    %wordBBox = r.WordBoundingBoxes(1,:);
                    %Iname = insertObjectAnnotation(image, 'rectangle', [grid_points(i,j,1), grid_points(i,j,2), wordBBox(3), wordBBox(4)], r.Text(1));
                    %imshow(Iname);
                    hletters(i,j) = r.Text(1);
                end
            else
                hletters(i,j) = '^';
            end
        end
    end
    letters = hletters;
    results = ocr(image, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
    bounding_boxes = zeros(length(results),4);
    for i = 1:length(results)
        bounding_boxes(i) = results(i).CharacterBoundingBoxes(:);
    end
end

