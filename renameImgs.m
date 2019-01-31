close all; clearvars;

%% Rename images in folder: trans, dapi, rna
% Run before uploading theimages intothe CP pipeline for segmentation

D = '/Users/eleanordegen/Documents/MATLAB/rajlabimagetools/testImages/SiqiTestImages/trainingRNA/20180625_19.2';
S = dir(fullfile(D,'*.png')); % pattern to match filenames.

k=1; % counter to track trans/dapi/rna group iterations
p=1; % count trans
q=1; % count dapi
r=1; % count rna

for j = 1:numel(S)
    F = fullfile(D,S(j).name);
    img = imread(F);
    imshow(img) % Show for fun
    if k==1
        i=p;
        imwrite(img,sprintf('trans_%i.tiff',i)) % Convert .png to .tiff
        p=p+1;
    elseif k==2
        i=q;
        imwrite(img,sprintf('dapi_%i.tiff',i)) 
        q=q+1;
    elseif k==3
        i=r;
        imwrite(img,sprintf('rna_%i.tiff',i)) 
        k=0; 
        r=r+1;
    end
    k=k+1;
    
end
