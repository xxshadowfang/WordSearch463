images = dir('images');
images = images(3:size(images, 1));

for i = 1:size(images, 1)
    image = imread(strcat('images/', images(i).name));
    words = importdata(strcat('words/', images(i).name, '.txt'));
    
    image = preprocess(image);
    
    [angle, hOffset, vOffset, hSpacing, vSpacing, gridPoints] = find_grid(image);
    
    letters = find_letters(image, gridPoints, hSpacing, vSpacing, angle)
    
    wordsFound = solve(letters, words);
    
    size(wordsFound)
end