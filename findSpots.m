%% File to process Siqi's FISH images
% Click "next" in the GUI to save thresholds
% After run findMatrices_training to find binary spot matrices

close all; clearvars; 
dirPath = '/Users/eleanordegen/Documents/MATLAB/rajlabimagetools/testImages/SiqiTestImages/trainingRNA';

filePattern = fullfile(dirPath, '*.tif'); % Read all png files
pngFiles = dir(filePattern);
    
% To store object info
graphBasedArray = cell(length(pngFiles),1);
objHolderArray = cell(length(pngFiles),1);
objHandleArray = cell(length(pngFiles),1);

% Iterate through images and process for spots
for i = 1:length(pngFiles)
    baseFileName = pngFiles(i).name;
    fullFileName = fullfile(dirPath, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    img = imread(fullFileName);
    imwrite(img,sprintf('rna00%i.tiff',i)) % Convert .png to .tiff
    sz = size(img);
    mask = ones(sz);

    % Create a graph-based object with imageObject node, rna channel node
    channelInfo.channelNames = {'rna'};
    channelInfo.fileNames = {sprintf('rna00%i.tiff',i)};
    graph = improc2.dataNodes.buildMinimalImageObjectGraph(mask, dirPath, channelInfo);
    graphBasedObj = improc2.dataNodes.GraphBasedImageObject();
    graphBasedObj.graph = graph;
    graphBasedObj.metadata.testField = 'testValue';
    
    % Set data in the channel stack container contained in the rna node
    graph.nodes{1,2}.data.croppedImage = img;
    graph.nodes{1,2}.data.croppedMask = mask;

    % Object holder for graph based image object
    objHolder = improc2.utils.ObjectHolder();
    objHolder.obj = graphBasedObj;
    objHolderArray(i) = {objHolder};

    % Handle to graph based image object
    objHandle = improc2.dataNodes.HandleToGraphBasedImageObject(objHolder);
    objHandleArray(i) = {objHandle};

    % Cell of graph-based objects
    graphBasedArray(i) = {graphBasedObj};
    
    % Processing to find spots
    x = improc2.dataNodes.ProcessorRegistrarForGraphBasedImageObject(objHolder);
    firstProcData = improc2.nodeProcs.aTrousRegionalMaxProcessedData(); % node to store data
    x.registerNewData(firstProcData, {'rna'}, 'rna:Spots'); % register data
    
    % Node to store manual threshold
    threshData = improc2.nodeProcs.ThresholdQCData(); 
    x.registerNewData(threshData, {'rna:Spots'}, 'rna:threshQC');

    % Run the processor with the "update all" functionality in Image Object tools
    channelName = {'rna'};
    imageProviders = dentist.utils.makeFilledChannelArray(...
        objHandle.channelNames, ...
        @(channelName) improc2.ImageObjectCroppedStkProvider(dirPath));
    objHandle.updateAllProcessedData(imageProviders);

    % Update the in memory array with spots data
    graphBasedArray(i) = {objHolder.obj};
end

% Launch the threshold GUI
inMem = improc2.utils.InMemoryObjectArrayCollection(graphBasedArray);
improc2.launchThresholdGUI(inMem);

% Save the array of object handles
save(objHandleArray,'handles');
