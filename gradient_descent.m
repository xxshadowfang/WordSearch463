function [ angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing ] = gradient_descent( points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing )

current_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing);

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset + 1, vertical_offset, horizontal_spacing, vertical_spacing);
    second_new_cost = cost(points, width, height, angle, horizontal_offset - 1, vertical_offset, horizontal_spacing, vertical_spacing);
    
    if(first_new_cost < current_cost)
        horizontal_offset = horizontal_offset + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        horizontal_offset = horizontal_offset - 1;
        current_cost = second_new_cost;
    end
end

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset + 1, horizontal_spacing, vertical_spacing);
    second_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset - 1, horizontal_spacing, vertical_spacing);
    
    if(first_new_cost < current_cost)
        vertical_offset = vertical_offset + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        vertical_offset = vertical_offset - 1;
        current_cost = second_new_cost;
    end
end

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing + 1, vertical_spacing);
    second_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing - 1, vertical_spacing);
    
    if(first_new_cost < current_cost)
        horizontal_spacing = horizontal_spacing + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        horizontal_spacing = horizontal_spacing - 1;
        current_cost = second_new_cost;
    end
end

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing + 1);
    second_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset, horizontal_spacing, vertical_spacing - 1);
    
    if(first_new_cost < current_cost)
        vertical_spacing = vertical_spacing + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        vertical_spacing = vertical_spacing - 1;
        current_cost = second_new_cost;
    end
end

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset + 1, vertical_offset, horizontal_spacing, vertical_spacing);
    second_new_cost = cost(points, width, height, angle, horizontal_offset - 1, vertical_offset, horizontal_spacing, vertical_spacing);
    
    if(first_new_cost < current_cost)
        horizontal_offset = horizontal_offset + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        horizontal_offset = horizontal_offset - 1;
        current_cost = second_new_cost;
    end
end

for i = 1:10
    first_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset + 1, horizontal_spacing, vertical_spacing);
    second_new_cost = cost(points, width, height, angle, horizontal_offset, vertical_offset - 1, horizontal_spacing, vertical_spacing);
    
    if(first_new_cost < current_cost)
        vertical_offset = vertical_offset + 1;
        current_cost = first_new_cost;
    elseif(second_new_cost < current_cost)
        vertical_offset = vertical_offset - 1;
        current_cost = second_new_cost;
    end
end

end