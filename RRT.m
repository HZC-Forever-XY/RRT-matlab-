%***************************************
%Author: Chaoqun Wang
%Date: 2019-10-15
%***************************************
%% ���̳�ʼ��
clear all; close all;
x_I=1; y_I=1;           % ���ó�ʼ��
x_G=700; y_G=700;       % ����Ŀ���
Thr=50;                 %����Ŀ�����ֵ
Delta= 30;              % ������չ����
probility = 0.4         % ���ò�������
%% ������ʼ��
T.v(1).x = x_I;         % T������Ҫ��������v�ǽڵ㣬�����Ȱ���ʼ����뵽T������
T.v(1).y = y_I; 
T.v(1).xPrev = x_I;     % ��ʼ�ڵ�ĸ��ڵ���Ȼ���䱾��
T.v(1).yPrev = y_I;
T.v(1).dist=0;          %�Ӹ��ڵ㵽�ýڵ�ľ��룬�����ȡŷ�Ͼ���
T.v(1).indPrev = 0;     %
%% ��ʼ������������ҵ����
figure(1);
ImpRgb=imread('newmap.png');
Imp=rgb2gray(ImpRgb);
imshow(Imp)
xL=size(Imp,1);%��ͼx�᳤��
yL=size(Imp,2);%��ͼy�᳤��
hold on
plot(x_I, y_I, 'ro', 'MarkerSize',10, 'MarkerFaceColor','r');
plot(x_G, y_G, 'go', 'MarkerSize',10, 'MarkerFaceColor','g');% ��������Ŀ���
count=1;
for iter = 1:3000
    x_rand=[];
    %Step 1: �ڵ�ͼ���������һ����x_rand
    %��ʾ���ã�x_rand(1),x_rand(2)����ʾ�����в���������� 
    x_rand = sampling(xL,yL,probility,x_G,y_G)
    x_near=[];
    %Step 2: ���������������ҵ�����ڽ���x_near 
    %��ʾ��x_near�Ѿ�����T��
    nearest = 9999999;
    near_index = -1;
    for index = 1:size(T.v,2)
        dis = distance(x_rand(1),x_rand(2),T.v(index).x,T.v(index).y);
        if dis<nearest
            nearest = dis;
            near_index = index;
        end
    end
    x_near(1) = T.v(index).x;
    x_near(2) = T.v(index).y;       
    x_new=[];
    %Step 3: ��չ�õ�x_new�ڵ�
    %��ʾ��ע��ʹ����չ����Delta
    l = distance(x_near(1),x_near(2),x_rand(1),x_rand(2));
    cos =(x_rand(1)-x_near(1))/l;
    sin =(x_rand(2)-x_near(2))/l;
    x_new(1) = x_near(1)+cos*Delta;
    x_new(2) = x_near(2)+sin*Delta;
    %���ڵ��Ƿ���collision-free
    if ~collisionChecking(x_near,x_new,Imp) 
        continue;
    end
    count=count+1;
    height = size(T.v,2);
    height = height+1;
    %Step 4: ��x_new������T 
    %��ʾ���½ڵ�x_new�ĸ��ڵ���x_nearg
    T.v(height).x = x_new(1);         % T������Ҫ��������v�ǽڵ㣬�����Ȱ���ʼ����뵽T������
    T.v(height).y = x_new(2); 
    T.v(height).xPrev = x_near(1);     % ��ʼ�ڵ�ĸ��ڵ���Ȼ���䱾��
    T.v(height).yPrev = x_near(2);
    T.v(height).dist=Delta;          %�Ӹ��ڵ㵽�ýڵ�ľ��룬�����ȡŷ�Ͼ���
    T.v(height).indPrev = near_index;     %
    %Step 5:����Ƿ񵽴�Ŀ��㸽�� 
    %��ʾ��ע��ʹ��Ŀ�����ֵThr������ǰ�ڵ���յ��ŷʽ����С��Thr����������ǰforѭ��
    d = distance(x_new(1),x_new(2),x_G,y_G);
    if d<Thr
        break;
    end
    
   %Step 6:��x_near��x_new֮���·��������
   %��ʾ 1��ʹ��plot���ƣ���ΪҪ�����ͬһ��ͼ�ϻ����߶Σ�����ÿ��ʹ��plot����Ҫ����hold on����
   %��ʾ 2�����ж��յ���������forѭ��ǰ���ǵð�x_near��x_new֮���·��������
   plot([x_near(1),x_new(1)],[x_near(2),x_new(2)],'-b');
   hold on;
   pause(0.1); %��ͣ0.1s��ʹ��RRT��չ�������׹۲�
end

%% ·���Ѿ��ҵ��������ѯ
if iter < 2000
    path.pos(1).x = x_G; path.pos(1).y = y_G;
    path.pos(2).x = T.v(height).x; path.pos(2).y = T.v(height).y;
    pathIndex = T.v(height).indPrev; % �յ����·��
    j=0;
    while 1
        path.pos(j+3).x = T.v(pathIndex).x;
        path.pos(j+3).y = T.v(pathIndex).y;
        pathIndex = T.v(pathIndex).indPrev;
        if pathIndex == 1
            break
        end
        j=j+1;
    end  % ���յ���ݵ����
    path.pos(end+1).x = x_I; path.pos(end).y = y_I; % ������·��
    for j = 2:length(path.pos)
        plot([path.pos(j).x; path.pos(j-1).x;], [path.pos(j).y; path.pos(j-1).y], 'b', 'Linewidth', 3);
    end
else
    disp('Error, no path found!');
end


