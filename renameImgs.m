close all; clearvars;

%% Rename images in folder: trans, dapi, rna
% Run before uploading theimages intothe CP pipeline for segmentation

D = '/Users/eleanordegen/Documents/MATLAB/rajlabimagetools/testImages/SiqiTestImages/trainingRNA/20180625_27.2';

pngFiles = dir('*.png'); % pattern to match filenames.
numfiles = length(pngFiles);

i=1;
for k = 1:(numfiles/3)
    img = imread(pngFiles(k).name);
    imshow(img) % Show for fun
    imwrite(img,sprintf('trans_%i.tiff',i)) % Convert .png to .tiff
    i=i+1;
    
    img = imread(pngFiles(k).name);
    imshow(img)
    imwrite(img,sprintf('dapi_%i.tiff',i))
    i=i+1;
    
    img = imread(pngFiles(k).name);
    imshow(img)
    imwrite(img,sprintf('rna_%i.tiff',i)) 
    i=i+1;
end
