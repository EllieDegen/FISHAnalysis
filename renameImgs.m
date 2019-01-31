close all; clearvars;

%% Rename images in folder: trans, dapi, rna
% Run before uploading theimages intothe CP pipeline for segmentation

D = '/Users/eleanordegen/Documents/MATLAB/rajlabimagetools/testImages/SiqiTestImages/trainingRNA/20180625_27.2';
S = dir(fullfile(D,'*.png')); % pattern to match filenames.

k=1; % counter to track trans/dapi/rna group iterations
for i = 1:numel(S)
    F = fullfile(D,S(i).name);
    img = imread(F);
    imshow(img) % Show for fun
    if k==1
        imwrite(img,sprintf('trans_%i.tiff',i)) % Convert .png to .tiff
        k=k+1;
    elseif k==2
        imwrite(img,sprintf('dapi_%i.tiff',i)) 
        k=k+1;
    elseif k==3
        imwrite(img,sprintf('rna_%i.tiff',i)) 
        k==1; % Return k to 1
    end
end
