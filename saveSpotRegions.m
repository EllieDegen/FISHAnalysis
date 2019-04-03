% save regions surrounding spots (to be processed by fitGaussian.py)
tic
allSpotRegions = cell(length(AllFilteredImgs),1);
for i=10:30%length(AllFilteredImgs)
    img = AllFilteredImgs{i,7};
    [x y] = find(img>0.4*max(img(:)));
    spotLocations = [x y];
    allSquares = cell(length(spotLocations),1);
    for j=1:length(spotLocations)
        width = 3;
        if spotLocations(j,1)-width>0 && spotLocations(j,1)+width<=size(img,1) % check for edge row
            rect = img(spotLocations(j,1)-width:spotLocations(j,1)+width,:);
            if spotLocations(j,2)-width>0 && spotLocations(j,2)+width<=size(img,2) % check for edge column
                square = rect(:,spotLocations(j,2)-width:spotLocations(j,2)+width);
%                 figure; 
%                 imshow(square,[],'InitialMagnification','fit')
%                 figure;
%                 [X,Y] = meshgrid(1:size(square,1),1:size(square,2));
%                 X = X(:); Y=Y(:); Z = square(:);
%                 scatter3(X,Y,Z);
%                 surf(square);
                allSquares{j} = double(square);
            end
        end 
    end
    allSpotRegions{i} = allSquares;
    toc
end
save('allSpotRegions.mat','allSpotRegions');