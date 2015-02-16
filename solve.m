function [ words_found ] = solve( grid, words )
words_found = [];

[~, Index] = sort(cellfun('size', words, 1), 'ascend');
sortWords = words(Index)
numWords = size(sortWords);

    for i = 1:(numWords(1,2))
        i
    solveWord = char(sortWords(i));
    
    words_found =vertcat( words_found,singleSolve(grid,solveWord))
    end
   
end



