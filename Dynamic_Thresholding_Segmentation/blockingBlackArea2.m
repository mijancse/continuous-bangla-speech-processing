% ----------------------------------------------------------------
% Blocking Black Area Method
% ----------------------------------------------------------------
function [dilatedImage]=blockingBlackArea(bw)
maxValue = double(max(bw(:)));      % Find the maximum pixel value
N = 350; % 355; 375;                           % Threshold number of white pixels
boxIndex = sum(bw) < N*maxValue;    % Find columns with fewer white pixels
boxImage = bw;                      % Initialize the box image
boxImage(:,boxIndex) = 0;           % Set the indexed columns to 0 (black)
%figure, imshow(boxImage);
%title('Boxes placed over dark area');
dilatedIndex = conv(double(boxIndex),ones(1,5),'same') > 0;  %# Dilate the index
dilatedImage = bw;                 %# Initialize the dilated box image
dilatedImage(:,dilatedIndex) = 0;  %# Set the indexed columns to 0 (black)

% Replace the column that contains fewer black pixels with 1 (white)
[m,n] = size(dilatedImage);
for i=1:n
    s(i) = sum(dilatedImage(:,i));
    if s(i)>0 && s(i)<m
        dilatedImage(:,i) = 1;
    end
end

%figure, imshow(dilatedImage);
%title('Dilated boxes placed over dark areas');
%figure('Position', [20 20 800 250], 'PaperPositionMode', 'auto', 'Visible', 'on');
%imshow(dilatedImage);
%print('-dpng', sprintf('sgm_black.png'));
% ----------------------------------------------------------------