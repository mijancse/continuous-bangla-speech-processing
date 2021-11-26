% The function testsegment(BW) is used to identify rectangular black boxes
% in the Binary image.
% With connecting sub-words

function [W Limits] = testsegment2(BW)
%
% Step 1: Invert the Binary Image
BW2 = ~ BW;
% Step 2: Find the boundaries Concentrate only on the exterior boundaries.
% Option 'noholes' will accelerate the processing by preventing
% bwboundaries from searching for inner contours. 
[B,L] = bwboundaries(BW2, 'noholes');
% Step 3: Determine objects properties
STATS = regionprops(L, 'all');  % we need 'BoundingBox' and 'Extent'
allArea = [STATS.Area];         % Areas of all objects

% Step 4: Indentify the rectangle shapes according to properties
% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
% UNKNOWN = 0
n1 = 0;
n0 = 0;
figure,imshow(BW);
%title('Segmented Result');
hold on
Limits = [];
fprintf('From Binary Image:\n');
fprintf('Total Segment= %d\n',length(STATS));
k = 1;
for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  centroid = STATS(i).Centroid;
  fprintf('Seg[%2d]. Area = %d\n',i,allArea(i));
  switch W(i)
      case 2
          if allArea(i)>4000
            plot(centroid(1),centroid(2),'wS');
            %[top-left top-right right-top right-bottom bottom-right bottom-left left-bottom left-top].
            extrema = STATS(i).Extrema;
            startSeg(i) = extrema(6);
            endSeg(i) = extrema(5);
                if i>1 && k>1 && (startSeg(i)-Limits(k-1,2))<13
                    Limits(k-1,2) = endSeg(i);
                    continue;
                end
            %fprintf(' : Start= %f End= %f\n',i,startSeg(i),endSeg(i));
            Limits = [Limits; startSeg(i) endSeg(i)];
            n1=n1+1;
            k = k+1;
          end
      otherwise
          plot(centroid(1),centroid(2),'wX');
          n0 = n0+1;
  end
end
%print('-dpng', sprintf(file_result));
fprintf('Words Segments = %d\n',k-1);