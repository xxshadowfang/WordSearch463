images = dir('images');
images = images(3:size(images, 1));

for i = 1:size(images, 1)
    image = imread(['images/' image]);
    words = importdata(['images/' image '.txt']);
    
    image = preprocess(image);
    
    [angle, hOffset, vOffset, hSpacing, vSpacing] = find_grid(image);
    
    letters = find_letters(image, angle, hOffset, vOffset, hSpacing, vSpacing);
    
    wordsFound = solve(letters, words);
    
    for i = 1:size(wordsFound, 1)
        word = wordsFound(1);
        row = wordsFound(2);
        col = wordsFound(3);
        dir = wordsFound(4);
    end
end