
import numpy as np
import cv2
import os, os.path
import glob

# Within a folder, there is one .png image containing total plate rna, and many Cells_x.tiff image masks
imagePath= "/Users/eleanordegen/Documents/CohenImageAnalysis/neuralnet/pythonSegment/rna_6.png"
totalrna = cv2.imread(imagePath) 
allmasks = [cv2.imread(file) for file in glob.glob("/Users/eleanordegen/Documents/CohenImageAnalysis/neuralnet/pythonSegment/*.tiff")] # cell masks

d=0
for x in allmasks:
    mask =  x
    # masked = cv2.multiply(totalrna,mask) # apply the mask

    # Determine coordinates of a box around the cell
    coords = np.nonzero(mask)
    rect = []
    rect.append(min(coords[0]))
    rect.append(max(coords[0]))
    rect.append(min(coords[1]))
    rect.append(max(coords[1]))

    # crop the total rna image
    cropped_img = totalrna[rect[0]:rect[1], rect[2]:rect[3]] 
    cropped_mask = mask[rect[0]:rect[1], rect[2]:rect[3]]

    # invert the mask
    mask_inv = cv2.bitwise_not(cropped_mask)
    coords2 = np.nonzero(mask_inv)
    for y in range(0,len(coords2[0])):
        cropped_img[coords2[0][y], coords2[1][y]] = 0 # set outside the cell = 0

    # save the cropped rna image
    cropped_img = cropped_img.sum(axis=2) # z-merge needed for findSpots.m
    savePath = "/Users/eleanordegen/Documents/CohenImageAnalysis/neuralnet/pythonSegment/"
    filename = "cropRNA_%d.tiff"%d
    cv2.imwrite(os.path.join(savePath, filename), cropped_img)
    d+=1

    # briefly display the cropped cell mask
    cv2.startWindowThread() # use highGUI windows
    cv2.namedWindow("image")
    cv2.imshow("image", cropped_mask)
    cv2.waitKey(500)

