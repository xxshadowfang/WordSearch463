function [isSol] = checkSol(endP,startP,grid)

dire = startP-endP;
dire(find(dire>0)) = 1;
dire(find(dire<0)) = -1;

is = 1==1;
while ((startP~=endP)&(is))
    if(grid(startP(1),startP(2))~=grid(endP(1),endP(2)))
        is= false
        grid(startP(1),startP(2))
        grid(endP(1),endP(2))
    end
    startP = startP+dire;
    %thanksgiving problem here
    
end
isSol =is;
end