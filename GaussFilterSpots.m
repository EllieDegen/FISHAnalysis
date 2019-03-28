% Gaussian filtration centered at all above-threshold points
function filteredimg = GaussFilterSpots(img,spotLocations,i)
old = img;
for j=1:length(spotLocations)
    width = 4;
    if spotLocations(j,1)-width>0 && spotLocations(j,1)+width<=size(img,1) % check for edge row
        rect1 = img(spotLocations(j,1)-width:spotLocations(j,1)+width,:);
        
        if spotLocations(j,2)-width>0 && spotLocations(j,2)+width<=size(img,2) % check for edge column
            square = rect1(:,spotLocations(j,2)-width:spotLocations(j,2)+width);
%             figure
%             imshow(square,[],'InitialMagnification','fit')
%             title('unfiltered')

            filteredsquare = imgaussfilt(square,0.45);
%             figure
%             imshow(filteredsquare,[],'InitialMagnification','fit')
%             title('filtered')
            img(spotLocations(j,1)-width:spotLocations(j,1)+width,...
                spotLocations(j,2)-width:spotLocations(j,2)+width) = filteredsquare;
        end
    end   
end


figure
imshow(old,[],'InitialMagnification','fit')
title1 = sprintf('Unfiltered Cell %i', i);
title(title1,'fontsize',14)
figure
imshow(img,[],'InitialMagnification','fit')
title2 = sprintf('Filtered Cell %i', i);
title(title2,'fontsize',14)
filteredimg=img;

end