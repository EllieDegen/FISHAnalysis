# Fitting adapted from https://scipy-cookbook.readthedocs.io/items/FittingData.html

from pylab import *
from numpy import *
from scipy import optimize
import scipy.io as sio
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import matplotlib.pyplot as plt


def gaussian(height, center_x, center_y, width_x, width_y):
     """Returns a gaussian function with the given parameters"""
     width_x = float(width_x)
     width_y = float(width_y)
     func = 0
     if width_y and width_x:
          func = lambda x,y: height*exp(
                    -(((center_x-x)/width_x)**2+((center_y-y)/width_y)**2)/2)
     return func

def moments(data):
     """Returns (height, x, y, width_x, width_y)
     the gaussian parameters of a 2D distribution by calculating its
     moments """
     width_x = width_y = 0
     total = data.sum()
     if total:
          X, Y = indices(data.shape)
          x = (X*data).sum()/total
          y = (Y*data).sum()/total
          col = data[:, int(y)]
          if col.sum():
               width_x = sqrt(abs((arange(col.size)-y)**2*col).sum()/col.sum())
          row = data[int(x), :]
          if row.sum():
               width_y = sqrt(abs((arange(row.size)-x)**2*row).sum()/row.sum())
     
     height = data.max()
     return height, x, y, width_x, width_y
 
def fitgaussian(data):
    """Returns (height, x, y, width_x, width_y)
    the gaussian parameters of a 2D distribution found by a fit"""
    params = moments(data)
    errorfunction = lambda p: ravel(gaussian(*p)(*indices(data.shape)) -
                                  data)
    p, success = optimize.leastsq(errorfunction, params)
    return p

# Load the spot regions for each LoG filtered single cell image
# allSpotRegions: a list where each row is a list of spot regions in the cell image
dictionary = sio.loadmat('allSpotRegions.mat') 
allSpotRegions = dictionary['allSpotRegions'] # list of lists
spotNum = 0
cellNum=0
for x in allSpotRegions: 
     for y in x:
          cellNum=cellNum+1
          for z in y:
               for w in z: # w is array[array] for each spot region
                    # print(w)
                    # print('check')
                    spotNum = spotNum+1
                           
                    data = w
                    params = fitgaussian(data)
                    fit = gaussian(*params)

                    # surface plot of the spot region
                    fig = plt.figure(figsize=plt.figaspect(0.5)) # figure twice as wide as it is tall
                    fig.suptitle('Cell {}, Spot Region {}'.format(cellNum,spotNum)) # main title
                    ax = fig.add_subplot(1, 2, 1, projection='3d') # first plot axis
                    X, Y = mgrid[0:len(data[0]), 0:len(data[0])]
                    Z = data
                    surf1 = ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.terrain,
                                        linewidth=0, antialiased=False)
                    ax.set_title("LoG filtered spot region")

                    # surface plot of the fitted Gaussian
                    ax = fig.add_subplot(1, 2, 2, projection='3d') # second plot axis
                    gauss = map(fit,X,Y)
                    gauss = np.array(gauss)
                    surf2 = ax.plot_surface(X, Y, gauss, rstride=1, cstride=1, cmap=cm.terrain,
                                        linewidth=0, antialiased=False)
                    ax.set_title("Fitted Gaussian")
                    imagename = "Cell{}SpotRegion{}.png".format(cellNum,spotNum)
                    plt.savefig(imagename)
                    # plt.show()
               
          spotNum=0 # re-set spot counter

