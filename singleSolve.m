function [word_found] = singleSolve(grid,word)

[row,col] = find(grid == word(1));
word_found = [];
starts = horzcat(row,col);
dirs= [0 1;1 0;0 -1;-1 -0;1 1;1 -1;-1 -1;-1 1];
[num,~] = size(starts);

[~,len] = size(word);


for j = 1:num
    
    start = starts(j,:);
    for k = 1:3
        start=vertcat(start,start);
    end
    
    A = start+(dirs*(len-1));
    B = abs(A);
    [~,loc] = ismember(B,A,'rows');
    C = A(nonzeros(loc),:);
    [gridR,gridC] = size(grid);
    [~,h] = size(C);
    
    for s = 1:h
        if(C(s,1)<=gridR&&C(s,2)<=gridC)
%             grid(C(s,1),C(s,2))
%             word(len)

            if(grid(C(s,1),C(s,2))==word(len))
                if(checkSol(C(s,:),start(1,:),grid))
                    sol = [start(1,:) C(s,:)];

                    word_found = vertcat(word_found, sol);

                end
            end
        end
    end
end

end