% Script that checks where spots lie within PCA clusters

load('LoGPCA.mat');
img = AllFilteredImgs{1,7};
figure;imshow(img,[],'InitialMagnification','fit')
% Testing case of img w/o much background
[row col] = find(img>(max(img(:))-3000)); % max of img 1 is 4688
spotLocations = [row col];

% find row of allCoordsAllCells{i} that contains [row col]
origCoords = allCoordsAllCells{25};
[a b] = find(origCoords(:,1)==spotLocations(1,1));
[c d] = find(origCoords(:,2)==spotLocations(1,2));
inter1 = intersect([a b],[c d]);
[a b] = find(origCoords(:,1)==spotLocations(6,1));
[c d] = find(origCoords(:,2)==spotLocations(6,2));
inter2 = intersect([a b],[c d]);
[a b] = find(origCoords(:,1)==spotLocations(12,1));
[c d] = find(origCoords(:,2)==spotLocations(12,2));
inter3 = intersect([a b],[c d]);
[a b] = find(origCoords(:,1)==spotLocations(18,1));
[c d] = find(origCoords(:,2)==spotLocations(18,2));
inter4 = intersect([a b],[c d]);
[a b] = find(origCoords(:,1)==spotLocations(24,1));
[c d] = find(origCoords(:,2)==spotLocations(24,2));
inter5 = intersect([a b],[c d]);
[a b] = find(origCoords(:,1)==spotLocations(28,1));
[c d] = find(origCoords(:,2)==spotLocations(28,2));
inter6 = intersect([a b],[c d]);


% PCA of image
[coefs scores] = pca(double(allFiltersAllCells{25,:}));
pcaRow = [inter1(2) inter2(2) inter3(2) inter4(2) inter5(2) inter6(2)];
x = scores(pcaRow,1);
y = scores(pcaRow,2);
figure
scatter(scores(:,1),scores(:,2))
hold on;
h=plot(x,y,'r.','MarkerSize',20);
title('Location of Spots: Cell 1','fontsize',14);
xlabel('PC1','fontsize',14);
ylabel('PC2','fontsize',14);
