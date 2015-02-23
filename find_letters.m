function [ letters, full_letters, bounding_boxes ] = find_letters( image, grid_points, horizontal_spacing, vertical_spacing, angle )
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
            if sortdist(1) < 0.5*min(horizontal_spacing,vertical_spacing)
                let = ones(31 + boxes(ind(1)).BoundingBox(4), 31 + boxes(ind(1)).BoundingBox(3));
                let(16:16+boxes(ind(1)).BoundingBox(4),15:15+boxes(ind(1)).BoundingBox(3)) = image(floor(boxes(ind(1)).BoundingBox(2)):floor(boxes(ind(1)).BoundingBox(2) + boxes(ind(1)).BoundingBox(4)), floor(boxes(ind(1)).BoundingBox(1)):floor(boxes(ind(1)).BoundingBox(1) + boxes(ind(1)).BoundingBox(3)));
                let = imrotate(let,180*angle/pi,'crop');
                %imtool(let);
                lettarr = char(zeros(4,1));
                confarr = zeros(4,1);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
                if numel(r.Text) == 0;
                    lettarr(1) = '^';
                    confarr(1) = 0;
                else
                    %wordBBox = r.WordBoundingBoxes(1,:);
                    %Iname = insertObjectAnnotation(image, 'rectangle', [grid_points(i,j,1), grid_points(i,j,2), wordBBox(3), wordBBox(4)], r.Text(1));
                    %imshow(Iname);
                    lettarr(1) = r.Text(1);
                    confarr(1) = r.CharacterConfidences(1);
                end
                let = imrotate(let,90);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
                if numel(r.Text) == 0;
                    lettarr(2) = '^';
                    confarr(2) = 0;
                else
                    %wordBBox = r.WordBoundingBoxes(1,:);
                    %Iname = insertObjectAnnotation(image, 'rectangle', [grid_points(i,j,1), grid_points(i,j,2), wordBBox(3), wordBBox(4)], r.Text(1));
                    %imshow(Iname);
                    lettarr(2) = r.Text(1);
                    confarr(2) = r.CharacterConfidences(1);
                end
                let = imrotate(let,90);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
                if numel(r.Text) == 0;
                    lettarr(3) = '^';
                    confarr(3) = 0;
                else
                    %wordBBox = r.WordBoundingBoxes(1,:);
                    %Iname = insertObjectAnnotation(image, 'rectangle', [grid_points(i,j,1), grid_points(i,j,2), wordBBox(3), wordBBox(4)], r.Text(1));
                    %imshow(Iname);
                    lettarr(3) = r.Text(1);
                    confarr(3) = r.CharacterConfidences(1);
                end
                let = imrotate(let,90);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
                if numel(r.Text) == 0;
                    lettarr(4) = '^';
                    confarr(4) = 0;
                else
                    %wordBBox = r.WordBoundingBoxes(1,:);
                    %Iname = insertObjectAnnotation(image, 'rectangle', [grid_points(i,j,1), grid_points(i,j,2), wordBBox(3), wordBBox(4)], r.Text(1));
                    %imshow(Iname);
                    lettarr(4) = r.Text(1);
                    confarr(4) = r.CharacterConfidences(1);
                end
                [newconf, I] = sort(confarr, 'descend');
                hletters(i,j) = lettarr(I(1));
            else
                hletters(i,j) = '^';
            end
        end
    end
    letters = hletters;
    results = ocr(image, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
    full_letters = results.Text;
    bounding_boxes = zeros(length(results.CharacterBoundingBoxes(:,1)),4);
    for i = 1:length(results.CharacterBoundingBoxes(:,1))
        bounding_boxes(i,:) = results.CharacterBoundingBoxes(i,:);
    end
end

