function [ letters ] = find_letters( image, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing )
    %instead of passing in angle, we should just rotate the image before
    %passing it in here.
    
    %Do we also need to return position of letters? Even if it's just
    %position in grid?
    for i = -10:10
        for j = -10:10
            %each letter, how do we know the size of the puzzle?
            thisletter = zeros(vertical_spacing, horizontal_spacing);
            thisletter(:) = image(vertical_offset+i*vertical_spacing:vertical_offset+(i+1)*vertical_spacing,horizontal_offset+j*horizontal_spacing:horizontal_offset+(j+1)*horizontal_spacing);
            results = ocr(I);
            word = results.Words(1)
        end
    end

end

