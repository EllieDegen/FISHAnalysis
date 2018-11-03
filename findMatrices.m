%% File to find binary spot matrices
close all; clearvars;
load('objHandleArray'); % load graph-based image data
%inMem = improc2.utils.InMemoryObjectArrayCollection(graphBasedArray);

% To store spot info
allSpotCounts = zeros(length(objHandleArray),1); 
allSpotMatrices = cell(length(objHandleArray),1); 
allZMerges = cell(length(objHandleArray),1);
allBinaryMatrices = cell(length(objHandleArray),1);

% Iterate through object handles and find binary spot matrices
for i = 1:length(objHandleArray)
   
    % Find over-threshold spots 
    handle = objHandleArray{i};
    [allSpotCounts(i), allSpotMatrices{i}] = getOverThreshSpots(handle,'rna:Spots');
    allZMerges{i} = allSpotMatrices{i}.zMerge; % may be useful
    
    % Populate spot matrix (y coordinate increases down rows)
    [y x z] = getSpotCoordinates(allSpotMatrices{i});
    spotMatrix = zeros(size(allZMerges{i}));
    for j = 1:allSpotCounts(i)
        spotMatrix(y(j),x(j)) = 1;
    end
    allBinaryMatrices{i} = spotMatrix;
end

save('findMatrices_final');

