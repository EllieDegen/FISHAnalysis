close all; clearvars; 
dirPath = '/Users/eleanordegen/Documents/CohenImageAnalysis/neuralnet/allCellMasks/27.2_1';
filePattern = fullfile(dirPath, 'rna*.tiff'); % Read all files
croppedRNAFiles = dir(filePattern);

AllFilteredImgs = cell(length(croppedRNAFiles),6); % filter each RNA image 6 times
AllPCA = cell(length(croppedRNAFiles),6); % to hold PCA of each filtered img
for i = 1:length(croppedRNAFiles)
    baseFileName = croppedRNAFiles(i).name;
    fullFileName = fullfile(dirPath, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    img = imread(fullFileName);
%     imshow(img,[],'InitialMagnification','fit')
%     title('Cropped RNA')
%     pause(1)
    imgcomp = imcomplement(img);
%     imshow(imgcomp,[],'InitialMagnification','fit');
%     title('Image Complement')
%     pause(1)
%     H = fspecial('log',[3 3]);
%     blurred = imfilter(imgcomp,H); 
%     imshow(blurred,[],'InitialMagnification','fit');
%     title('LoG Filtered')
%     pause(1)
    
    for j=3:9
        H2 = fspecial('log',[j j]);
        AllFilteredImgs{i,j} = imfilter(imgcomp,H2);
%         AllPCA{i,j} = pca(double(AllFilteredImgs{i,j}));
    end
end
save('LoGFilters.mat');