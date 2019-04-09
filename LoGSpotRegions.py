import numpy as np
import scipy.io as sio
from skimage import data
from skimage.feature import blob_log
from skimage.color import rgb2gray
import matplotlib.pyplot as plt

# load original single cell images (from plate segmentation)
dictionary = sio.loadmat('allOrigImgs.mat') 
allOrigImgs = dictionary['allOrigImgs'] # list of 1x1 arrays, each holding an image

# loop through all images
for index in allOrigImgs:
    for im in index:
        # im = (im/256).astype('uint8') # convert to 8 bit
        im = im/im.max()

        # blob detection
        image_gray = rgb2gray(im)
        # print(image_gray)

        blobs_log = blob_log(image_gray,min_sigma=1, max_sigma=2, num_sigma=1000, threshold=0.02, overlap=0.5, log_scale=False, exclude_border=True) # Laplacian of Gaussian

        plt.imshow(im, cmap='gray', interpolation='nearest')
        ax = plt.gca()
        for blob in blobs_log:
            y, x, r = blob
            print('x: {}, y: {}'.format(x,y))
            c = plt.Circle((x, y), r, color='r', linewidth=2, fill=False)
            ax.add_patch(c)
       
        plt.title('LoG Detected Spots')
        plt.show()
        # plt.pause(3)
        plt.close()

 



