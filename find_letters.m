function [ letters ] = find_letters( image, grid_points, horizontal_spacing, vertical_spacing )
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
            if sortdist(1) < 1.0*min(horizontal_spacing,vertical_spacing)
                let = image(floor(boxes(ind(1)).BoundingBox(2)-20):floor(boxes(ind(1)).BoundingBox(2) + boxes(ind(1)).BoundingBox(4)+20), floor(boxes(ind(1)).BoundingBox(1)-20):floor(boxes(ind(1)).BoundingBox(1) + boxes(ind(1)).BoundingBox(3)+20));
                %imtool(let);
                r = ocr(let, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout', 'Block');
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
    bletters = transpose(hletters);
    cletters = bletters;
    for i = 1:size(cletters,1)
        cletters(i,:) = bletters(size(cletters,1)-(i-1),:);
    end
    letters = cletters;
    for i = 1:size(letters,2)
        letters(:,i) = cletters(:,size(letters,2)-(i-1));
    end
end

