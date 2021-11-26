% focused time-delay neural network (FTDNN).
clc; clear all; close all;
y = laser_dataset;
y = y(1:600);
ftdnn_net = timedelaynet([1:8],10);
ftdnn_net.trainParam.epochs = 500;
ftdnn_net.divideFcn = '';
p = y(9:end);
t = y(9:end);
Pi=y(1:8);
ftdnn_net = train(ftdnn_net,p,t,Pi);
yp = ftdnn_net(p,Pi);
e = gsubtract(yp,t);
rmse = sqrt(mse(e))
