% Script that checks where spots lie within PCA clusters
close all; clear vars;
load('LoGPCA.mat');
spotLocations_AllCells = cell(length(AllFilteredImgs),1);
allLatentVectors = cell(length(AllFilteredImgs),1);
allExplainedVectors = cell(length(AllFilteredImgs),1);
tic
for i=1:25%length(AllFilteredImgs)
    unfiltered = AllFilteredImgs{i,1};
    img = AllFilteredImgs{i,7};
    centroids = fitSpots(img,i,unfiltered); % find spot locations
    centroids = round(centroids);
    spotLocations = [centroids(:,2) centroids(:,1)];
    
    % find row of allCoordsAllCells{i} that contains [row col]
    origCoords = allCoordsAllCells{i};
    inter = ones(length(spotLocations),2);
    for j=1:size(spotLocations,1)
        [a b] = find(origCoords(:,1)==spotLocations(j,1));
        [c d] = find(origCoords(:,2)==spotLocations(j,2));
        inter(j,:) = intersect([a b],[c d]);
    end

    % PCA of image
    [coeff,scores,latent,tsquared,explained,mu] = pca(double(allFiltersAllCells{i,:}));
    allExplainedVectors{i} = explained;
    allLatentVectors{i} = latent;
    x=scores(inter(1:end,2),1);
    y=scores(inter(1:end,2),2);

    % Plot largest principal components (all indices and spots)
    fig = figure;
    scatter(scores(:,1),scores(:,2));
    hold on;
    plot(x,y,'r.','MarkerSize',20);
    str = sprintf('PCA Location of Spots: Cell %i', i);
    title(str,'fontsize',14);
    xlabel('PC1','fontsize',14);
    ylabel('PC2','fontsize',14);
    name = sprintf('LocationOfSpots_Cell%i', i);
%     saveas(fig,name,'jpeg');
    
toc
end
save('checkIfClustersHoldSpots.mat');
