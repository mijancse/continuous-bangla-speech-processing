%%%%%%%% CHARACTER RECOGNITION USING BACK PROPAGATION ALGORITHM %%%%%%%%%

% This code solves the problem of character recognition using Back
% Propagation Algorithm. 
%%%%%%%%%%%%%%% Code Starts%%%%%%%%%%%%%%%%%%%
a=[
    0 0 0 1 0 0 
    0 0 1 0 1 0 
    0 1 0 0 0 1 
    0 1 1 1 1 1
    0 1 0 0 0 1
    1 0 0 0 0 1
    ];

b=[
    1 1 1 1 1 0 
    1 0 0 0 0 1 
    1 1 1 1 1 0 
    1 0 0 0 1 0
    1 0 0 0 0 1
    1 1 1 1 1 0
    ];

c=[
    1 1 1 1 1 1 
    1 0 0 0 0 0 
    1 0 0 0 0 0 
    1 0 0 0 0 0
    1 0 0 0 0 0
    1 1 1 1 1 1
    ];

d=[
    1 1 1 1 0 0 
    1 0 0 0 1 0 
    1 0 0 0 0 1 
    1 0 0 0 0 1
    1 0 0 0 1 0
    1 1 1 1 0 0
    ];

e=[
    1 1 1 1 1 1 
    1 0 0 0 0 0 
    1 1 1 1 1 1 
    1 0 0 0 0 0
    1 0 0 0 0 0
    1 1 1 1 1 1
    ];

f=[
    1 1 1 1 1 1 
    1 0 0 0 0 0 
    1 1 1 1 1 1 
    1 0 0 0 0 0
    1 0 0 0 0 0
    1 0 0 0 0 0
    ];

g=[
    1 1 1 1 1 1 
    1 0 0 0 0 0 
    1 0 0 0 0 0 
    1 0 1 1 1 1
    1 0 0 0 0 1
    1 1 1 1 1 0
    ];

h=[
    1 0 0 0 0 1 
    1 0 0 0 0 1 
    1 0 0 0 0 1 
    1 1 1 1 1 1
    1 0 0 0 0 1
    1 0 0 0 0 1
    ];

i0=[
    1 1 1 1 1 1 
    0 0 0 1 0 0 
    0 0 0 1 0 0 
    0 0 0 1 0 0
    0 0 0 1 0 0
    1 1 1 1 1 1
    ];

j0=[
    1 1 1 1 1 1 
    0 0 0 1 0 0 
    0 0 0 1 0 0 
    1 0 0 1 0 0
    1 0 0 1 0 0
    0 1 1 0 0 0
    ];

a1=[]
for i=1:6
    for j=1:6
        a1=[a1;a(i,j)];
    end
end

b1=[]
for i=1:6
    for j=1:6
        b1=[b1;b(i,j)];
    end
end

c1=[]
for i=1:6
    for j=1:6
        c1=[c1;c(i,j)];
    end
end

d1=[]
for i=1:6
    for j=1:6
        d1=[d1;d(i,j)];
    end
end

e1=[]
for i=1:6
    for j=1:6
        e1=[e1;e(i,j)];
    end
end

f1=[]
for i=1:6
    for j=1:6
        f1=[f1;f(i,j)];
    end
end

g1=[]
for i=1:6
    for j=1:6
        g1=[g1;g(i,j)];
    end
end

h1=[]
for i=1:6
    for j=1:6
        h1=[h1;h(i,j)];
    end
end

i1=[]
for i=1:6
    for j=1:6
        i1=[i1;i0(i,j)];
    end
end

j1=[]
for i=1:6
    for j=1:6
        j1=[j1;j0(i,j)];
    end
end

le=[a1 b1 c1 d1 e1 f1 g1 h1 i1 j1];
t=eye(10);
net=newff(minmax(le),[40,10],{'tansig','purelin'},'traingd');
net.trainParam.epochs = 1000;
net.trainParam.goal=1e-2;
net.trainParam.lr=0.01;
net.trainParam.mc=0.1
net = train(net,le,t);
Y = sim(net,le);
cor=0;
for i=1:10
    max=1;
    for j=1:10
        if Y(j,i)>Y(max,i)
            max=i;
        end
    end
    if max==i
        cor=cor+1;
    end
end

'Train Cases Recognized'
cor

'Train Cases Recognition Accuracy'
cor/10*100

% Test Image
a=[
    1 1 1 1 1 1 
    1 0 0 0 0 0 
    1 1 1 1 1 1 
    1 0 0 0 0 0
    1 0 0 0 0 0
    1 1 1 1 1 1
    ];

a1=[];
for i=1:6
    for j=1:6
        a1=[a1;a(i,j)];
    end
end
a2=sim(net,a1);

'Output vector for test image'
a2
max=1;
for j=1:10
    if a2(j)>a2(max)
        max=j;
    end
end
'test image output'
max
