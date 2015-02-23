function [ words_found ] = solve( grid, words )
words_found = [];

[~, Index] = sort(cellfun('size', words, 1), 'ascend');
sortWords = words(Index);

    for i = 1:size(sortWords, 1)
        solveWord = char(sortWords(i));
        
        words_found = vertcat(words_found, find_word(grid, solveWord));
    end
   
end



