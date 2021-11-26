function level = fcmthresh(IM)
% FCMTHRESH Thresholding by 3-class fuzzy c-means clustering
%  [bw,level]=fcmthresh(IM,sw) outputs the binary image bw and threshold level of
%  image IM using a 3-class fuzzy c-means clustering. It often works better
%  than Otsu's methold which outputs larger or smaller threshold on
%  fluorescence images.
%  sw is 0 or 1, a switch of cut-off position.
%  sw=0, cut between the small and middle class
%  sw=1, cut between the middle and large class
%
%  Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.
%
% check the parameters
% if (nargin<1)
%     error('You must provide an image.');
% elseif (nargin==1)
%     sw=0;
% elseif (sw~=0 && sw~=1)
%     error('sw must be 0 or 1.');
% end
% B = reshape(A,m,n) returns the m-by-n matrix B whose elements are taken 
% column-wise from A. An error results if A does not have m*n elements.
% -----------------------------------------------------------------------
  data=reshape(IM,[],1);
%
% Fuzzy c-means clustering
% [center,U,obj_fcn] = fcm(data,cluster_n) 
% data: data set to be clustered;
% cluster_n: number of clusters (greater than one)
% center: matrix of final cluster centers 
% U: final fuzzy partition matrix (or membership function matrix) 
% obj_fcn: values of the objective function during iterations
%
% [B,IX] = sort(A,...) also returns an array of indices IX, 
% where size(IX) == size(A). If A is a vector, B = A(IX).
% -----------------------------------------------------------------------
[center,member]=fcm(data,3);
[center,cidx]=sort(center);
center = sort(center);
level=(center(2)+center(3))/2;
% bw=im2bw(IM,level);
