input = [1 0 0 1 1;...
         1 0 0 0 1;...
    1     0     0     0     1;...
    1     0     0     0     1;...
    0     0     1     0     0;...
    0     1     1     1     0;...
    0     1     1     1     0];
T = ones(size(input, 1));
net = newff(input,T,[35], {'logsig'});
%net.performFcn = 'sse';
net.divideParam.trainRatio = 1; % training set [%]
net.divideParam.valRatio   = 0; % validation set [%]
net.divideParam.testRatio  = 0; % test set [%]
net.trainParam.goal = 0.001;
[net tr] = train(net,input,T);