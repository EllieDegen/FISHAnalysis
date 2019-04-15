# PCA of single cell images. Saves a matrix where rows correspond to linear index 
# in the original image and columns the pixel value for increasingly sized LoG filters

import numpy as np
import pandas as pd
from sklearn.decomposition import PCA
from scipy import ndimage, misc
import matplotlib.pyplot as plt
import cv2
import os, os.path
import glob
from skimage.feature import blob_log
from skimage.color import rgb2gray

# load all images from a folder
dirPath = "/Users/eleanordegen/Documents/CohenImageAnalysis/neuralnet/allCellMasks/27.2_1/croppedRNA/*.tiff"
allCells = [cv2.imread(file, cv2.IMREAD_ANYDEPTH) for file in glob.glob(dirPath)]

allCellsAllFiltrations = list()
for x in allCells:
    orig = x
    img = cv2.bitwise_not(orig) # invert image (prep for LoG)
    
    filterSizes = [1, 3, 5, 7, 9, 11]
    allFiltrations = list()
    allUnraveled = [None] * len(filterSizes)
    i = 0
    for x in filterSizes: 
        blur = cv2.GaussianBlur(img,(x,x),0) # gaussian blur
        log = cv2.Laplacian(blur,cv2.CV_64F, ksize=x) # laplacian of gaussian
        allFiltrations.append(log)
        allUnraveled[i] = np.ravel(log) 
        i = i+1
    allCellsAllFiltrations.append(allFiltrations)
    allUnraveled = np.asarray(allUnraveled)
    
    # overlay LoG detected spots on original image
    im = orig
    im= im/im.max()
    image_gray = rgb2gray(im)
    blobs_log = blob_log(image_gray,min_sigma=1, max_sigma=2, num_sigma=1000, 
        threshold=0.025, overlap=0.5, log_scale=False, exclude_border=True) 

    fig1 = plt.figure()
    ax1 = fig1.add_subplot(121) 
    plt.imshow(orig, cmap='gray', interpolation='nearest')

    spotNum = 0 
    allX = list()
    allY = list()
    for blob in blobs_log:
        spotNum = spotNum+1 # track spot number
        Y, X, R = blob
        r = int(round(R))
        y = int(round(Y))
        x = int(round(X))
        allX.append(x)
        allY.append(y)
        print('x: {}, y: {}, r: {}'.format(x,y,r))
        c1 = plt.Circle((X, Y), R, color='r', linewidth=2, fill=False)
        ax1.add_patch(c1)

    # linear spot coords for PCA plot
    spotIndices = np.asarray([np.asarray(allY), np.asarray(allX)])
    linearSpotIndices = np.ravel_multi_index(spotIndices, orig.shape) 
    LSIs = linearSpotIndices
    print(LSIs)
    
    # PCA of filtrations
    pca = PCA(n_components=2)
    pca.fit(allUnraveled)
    X = pca.components_

    # Plot PCA 
    ax2 = fig1.add_subplot(122)
    ax2.scatter(X[0], X[1],color='b')
    plt.xlabel('PC1')
    plt.ylabel('PC2')
    ax2.scatter(X[0][LSIs],X[1][LSIs],color='r') # spot locations in red

    # Plot filtered images
    plt.gray()
    fig2 = plt.figure()
    ax1 = fig2.add_subplot(141)  
    ax1.imshow(allFiltrations[0])
    plt.title('Filter Width = 1')
    ax2 = fig2.add_subplot(142)  
    ax2.imshow(allFiltrations[1])
    plt.title('Filter Width = 3')
    ax3 = fig2.add_subplot(143)  
    ax3.imshow(allFiltrations[2])
    plt.title('Filter Width = 5')
    ax4 = fig2.add_subplot(144)  
    ax4.imshow(allFiltrations[3])
    plt.title('Filter Width = 7')
    
    plt.show()
   
