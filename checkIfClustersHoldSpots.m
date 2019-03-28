% Script that checks where spots lie within PCA clusters
close all; clear vars;
load('LoGPCA.mat');
spotLocations_AllCells = cell(length(AllFilteredImgs),1);
allLatentVectors = cell(length(AllFilteredImgs),1);
allExplainedVectors = cell(length(AllFilteredImgs),1);
tic
for i=1:length(AllFilteredImgs)
    orig = AllFilteredImgs{i,7};
%     figure;imshow(img,[],'InitialMagnification','fit')
    [row col] = find(orig>(0.4*max(orig(:)))); % find over-threshold spot indices
    spotLocations = [row col];
    img = GaussFilterSpots(orig,spotLocations,i); % guassian filter at spots
    [row col] = find(img>(0.4*max(orig(:)))); % update spot indices
    spotLocations = [row col];
    spotLocations_AllCells{i} = spotLocations; % store index of spot
    
    
    
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
    str = sprintf('Location of Spots: Cell %i', i);
    title(str,'fontsize',14);
    xlabel('PC1','fontsize',14);
    ylabel('PC2','fontsize',14);
    name = sprintf('LocationOfSpots_Cell%i', i);
%     saveas(fig,name,'jpeg');
    
%     % Add in the maximum in green
%     hold on;
%     [row col] = find(img==(max(img(:)))); 
%     [a b] = find(origCoords(:,1)==spotLocations(j,1));
%     [c d] = find(origCoords(:,2)==spotLocations(j,2));
%     index = intersect([a b],[c d]);
%     x2=scores(index(2),1);
%     y2=scores(index(2),2);
%     plot(x,y,'g.','MarkerSize',20);
    
toc
end
save('checkIfClustersHoldSpots.mat');
