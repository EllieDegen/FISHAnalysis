function centroids = findSpotsUsingCentroids(img,i,unfiltered)
  
    I2 = img > 0.4*max(img(:));
    [labeledImage, numberOfCircles] = bwlabel(I2); % find regions of interest
    s = regionprops(labeledImage,'centroid'); % find centroids of regions
    centroids = cat(1, s.Centroid);
    
    % overlay spot locations on unfiltered image
    figure;  
    imshow(unfiltered,[],'InitialMagnification','fit')
    hold on
    plot(centroids(:,1), centroids(:,2), 'gO','MarkerSize',10)
    hold off
    str = sprintf('Fitted Spots: Cell %i', i);
    title(str,'fontsize',14);
    
end