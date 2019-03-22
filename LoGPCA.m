% reduce image dimensionality
% pca(X)- Rows of X correspond to observations and columns correspond to variables. 
load('LoGFilters.mat');
allFiltersAllCells = cell(length(AllFilteredImgs),1);
allCoordsAllCells = cell(length(AllFilteredImgs),1);

tic
for i=1:length(AllFilteredImgs)
    threeD = cat(3,AllFilteredImgs{i,1},AllFilteredImgs{i,2},AllFilteredImgs{i,3},...
        AllFilteredImgs{i,4},AllFilteredImgs{i,5},AllFilteredImgs{i,6},AllFilteredImgs{i,7});
    
    origCoords = zeros(size(AllFilteredImgs{i,1},1)*size(AllFilteredImgs{i,1},2),2);
    allFilters = zeros(size(AllFilteredImgs{i,1},1)*size(AllFilteredImgs{i,1},2),size(AllFilteredImgs,2));
    count=1;
    for j=1:size(AllFilteredImgs{i,1},1)
        for k=1:size(AllFilteredImgs{i,1},2)
           newRow = reshape(threeD(j,k,:),[1 size(AllFilteredImgs,2)]);
           % store the original coordinates
           origCoords(count,:) = [j k];
           allFilters(count,:) = newRow;
           allFiltersAllCells{i}=allFilters;
           allCoordsAllCells{i}=origCoords;
           count=count+1;
        end
    end
    toc
end

% [coefs scores] = pca(double(allIndicesAllCells{1,:}));
% scatter(scores(:,1),scores(:,2))

save('LoGPCA.mat');
