% Fuzzy c-means clustering
% [center,U,obj_fcn] = fcm(data,cluster_n) 
% The input arguments of this function are
% •	data: data set to be clustered; each row is a sample data point
% •	cluster_n: number of clusters (greater than one)
% The output arguments of this function are
% •	center: matrix of final cluster centers where each row provides the center coordinates
% •	U: final fuzzy partition matrix (or membership function matrix) 
% •	obj_fcn: values of the objective function during iterations

clc;
data = rand(100, 2);
[center,U,obj_fcn] = fcm(data, 3);
plot(data(:,1), data(:,2),'o');
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2, :) == maxU);
line(data(index1,1),data(index1, 2),'linestyle','none',...
     'marker','*','color','g');
line(data(index2,1),data(index2, 2),'linestyle','none',...
     'marker', '*','color','r');