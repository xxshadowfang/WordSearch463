function [ location ] = find_word(letters, word)
location = [];

directions = [0, 1; -1, 1; -1, 0; -1, -1; 0, -1; 1, -1; 1, 0; 1, 1];

for i = 1:size(letters, 1)
    for j = 1:size(letters, 2)
        for k = 1:size(directions, 1)
            same = 1;
            
            for l = 1:length(word)
                if letters(mod(i + (l - 1) * directions(k, 1) - 1, size(letters, 1)) + 1, mod(j + (l - 1) * directions(k, 2) - 1, size(letters, 2)) + 1) ~= word(l)
                    same = 0;
                    break;
                end
            end
            
            if same
                location = [i, j, i + (length(word) - 1) * directions(k, 1), j + (length(word) - 1) * directions(k, 2)];
            end
        end
    end
end

end