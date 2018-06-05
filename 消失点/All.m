sourcePic=imread('E.jpg');
sourcePic=rgb2gray(sourcePic);

sourcePic=im2double(sourcePic);

%使用水平和垂直Sobel算子,自动选择阈值 
edgePic=edge(sourcePic,'sobel','horizontal'); 
figure,imshow(edgePic),title('水平图像边缘检测'); % 显示边缘探测图像 

edgePic=edge(sourcePic,'sobel','vertical'); 

figure,imshow(edgePic),title('垂直图像边缘检测'); % 显示边缘探测图像 

edgePic=edge(sourcePic,'sobel'); 

[height,width]=size(edgePic); 

 %图像中直线的个数
 LINE_COUNT = 100;
 
 % Hough变换检测直线，g(x)=(a,p)为边界点对应的平面  
 ma=180; %a的值为0到180度  

 mp=round(sqrt(height^2+width^2)); %对应P的最大值  

 npc=zeros(ma,2*mp); %用于记录(a,p)对应的点的个数  
 
 MAP=zeros(height, width);
 
 npp=cell(ma,2*mp); %用于记录(a,p)对应的点的坐标  
 
 for i=1:height %计算(a,p)的值，并做相应记录  

     for j=1:width  

         if(edgePic(i,j)==1)  

             for k=1:ma
                 p = round(i*cos(pi*k/180)+j*sin(pi*k/180));
                 npc(k,mp+p)=npc(k,mp+p)+1;
                 npp{k,mp+p}=[npp{k,mp+p},[i,j]'];
             end  

         end  

     end  

 end


LNum = 0;                       %得到的直线的数目
LPC = zeros(LINE_COUNT,6);      %直线的参数集合 元素为 [Number][k][b][a][p][DP]   分别为直线的: 编号 斜率 截距 角度a 弦长p 是否为消失线
index = 1;


%提取直线的阀值
LT = 90;

for i=1:ma      

     for j=1:mp*2  

         if(npc(i,j) > LT) 
             
                lk= -cot(pi*i/180);
                lb= round((j - mp - 1)/sin(pi*i/180));

                %保存直线的参数，顺序为 编号 (k,b) (a,p)
                LNum = LNum + 1;
                
                LPC(index,1) = LNum;%存储直线的编号
                LPC(index,2) = lk;
                LPC(index,3) = lb;
                LPC(index,4) = i;
                LPC(index,5) = j;
                
                index = index + 1;
                
                lp=npp{i,j};
                for k=1:npc(i,j)
                     MAP(lp(1,k),lp(2,k))=1;  
                end
         end  

     end  

end  

figure,imshow(MAP);title('检测出的直线图');

%求出总共有多少交点
InterCount = LNum*(LNum - 1)*0.5;

LInter = zeros(InterCount,4);           %直线的交点集合 元素为 两条相交直线的编号 i,j 和 交点坐标 x,y . 有 i < j
                                        %元素个数为 n*(n - 1)/2
%下面的代码是求直线的交点
T =1;

LIC = 0;                                %直线交点的个数

for i = 1:LNum - 1
    for j = i + 1:LNum
        
        k1 = LPC(i,2);
        b1 = LPC(i,3);

        k2 = LPC(j,2);
        b2 = LPC(j,3);
        
        dp = k1 - k2;                   %得到两条直线斜率之差
        
        if(abs(dp - 0) > 10e-03)        %如果斜率之差太小，就可以认为这两条直线平行而没有交点。
            
            LIC = LIC + 1;              %直线交点个数加一
            
            X = (b2 - b1)/(k1 - k2);    % X = (b2 - b1)/(k1 - k2)
            Y = k1 * X + b1;            % Y = k1 * X + b1
            LInter(LIC,1) = i;
            LInter(LIC,2) = j;
            LInter(LIC,3) = round(X);
            LInter(LIC,4) = round(Y);
            
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下的部分是求消失点和消失线的参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TDist = 10;                 %距离的阀值
count = 1;

PANum = zeros(InterCount,1);

for i = 1:LIC - 1
    for j = i + 1:LIC
        
        %求两点之间的距离
        DX = LInter(i,3) - LInter(j,3);
        DY = LInter(i,4) - LInter(j,4);
        
        dist = round(sqrt(DX^2 + DY^2));
        
        %如果距离小于一定的阀值，则认为这两点相交
        if(dist < TDist)    
              PANum(i,1) = PANum(i,1) + 1;
              PANum(j,1) = PANum(j,1) + 1;
        end
        
    end
end

MaxNum = max(PANum);
DispX = 0;
DispY = 0;
count = 0;
index = 1;

DispLine = zeros(LNum,2);
DRAW = zeros(height,width);


%得到消失点和消失线的参数
for i=1:LIC
    if(MaxNum == PANum(i,1))
        DispX = DispX + LInter(i,3);
        DispY = DispY + LInter(i,4);
        
        ind1 = LInter(i,1);
        ind2 = LInter(i,2);
        
        LPC(ind1,6) = 1;        %这条直线为消失线
        
        LPC(ind2,6) = 1;        %这条直线为消失线
        count = count + 1;
    end
end


%求出消失点的坐标
if(count > 0)
    DispX = DispX/count;
    DispY = DispY/count;
end

DX = 0;
DY = 0;

if(DispX < 0)
    DX = round(abs(DispX)) + 10;
end

if(DispY < 0)
    DY = round(abs(DispY)) + 10;
end

PMAP = zeros(height + DX, width + DY);

%绘制消失线
for n = 1:LNum
    %根据消失线的参数方程绘制消失线
    if(LPC(n,6) == 1)
        for Y=1:width
                X = round((Y - LPC(n,3))/LPC(n,2));
                if(X > 0 && X < height)
                    PMAP(X + DX, Y + DY) = 1;
                end
        end
    end
end

%画出消失点
for i = -5:5
    for j = -5:5
        PMAP(round(DispX + DX + i), round(DispY + DY + j)) = 1;
    end
end


figure,imshow(PMAP);title('消失点和消失线');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下的部分是求深度图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%定义深度图数组
Depth = zeros(height, width);

%消失线参数数组 元素为[k][b]
PA = zeros(2,2);

%求斜率最小的消失线的参数
DIST = zeros(LPC,1);

for i = 1:LNum
    DIST(i,1) = LPC(i,2)*height + LPC(i,3);
end

[LIN,index] = min(DIST);
PA(1,1) = LPC(index,2); %直线斜率k
PA(1,2) = LPC(index,3); %直线截距b

[LOUT,index] = max(DIST);

%求斜率最大的消失线的参数
PA(2,1) = LPC(index,2); %直线斜率k
PA(2,2) = LPC(index,3); %直线截距b

%校正过后的消失点
BeginX = (PA(2,2) - PA(1,2))/(PA(1,1) - PA(2,1));
BeginY = PA(1,1)*BeginX + PA(1,2);

%求直线l3的表达式,根据直线 l1 l2 的交点和直线 l1 l2 的表达式
a1 = atan(PA(1,1));
if(a1 < 0)
    a1 = a1 + pi;
end

a2 = atan(PA(2,1));
if(a2 < 0)
    a2 = a2 + pi;
end

a3 = (a1 + a2)/2;
k3 = tan(a3);
b3 = (BeginY - k3*BeginX);



if(abs(pi/2 - a3) < pi/4)

    TX1 = 1;
    TY1 = PA(2,1) + PA(2,2);
    
    TX2 = height;
    TY2 = PA(1,1)*TX2 + PA(1,2);
    
    
    D1 = sqrt((BeginX - TX1)^2 + (BeginY - TY1)^2);
    D2 = sqrt((BeginX - TX2)^2 + (BeginY - TY2)^2);
   
    if(D1 > D2)
        EndX = TX1;
        EndY = TY1;
    else
        EndX = TX2;
        EndY = TY2;
    end
    
    WidthMax = sqrt((BeginX - EndX)^2 + (BeginY - EndY)^2);
    
    %单位深度得亮度值
    dDV = 255/WidthMax;
    
    KTBegin = -1/k3;
    BTBegin = BeginY - BeginX*KTBegin;
    
    KTEnd = -1/k3;
    BTEnd = EndY - EndX*KTEnd;
    
    for B = round(BTBegin):-1:round(BTEnd)
        JX1 = (PA(2,2) - B)/(KTBegin - PA(2,1));
        JY1 = KTBegin*JX1 + B;

        JX2 = (PA(1,2) - B)/(KTBegin - PA(1,1));
        JY2 = KTBegin*JX2 + B;
    
        if(JX1 > JX2)
            Step = -1;
        else
            Step = 1;
        end
        
        LWidth = sqrt((JX1 - JX2)^2 + (JY1 - JY2)^2);
        
        for i = round(JX1):Step:round(JX2)
            j = round(KTBegin*i + B);
            if(i > 0 && i < height)
                if(j > 0 && j < width)
                    Depth(i,j) = LWidth*dDV/255;
                end
            end
        end
        
        i = round(JX1);
        for j = round(JY1):1:width
             if(i > 0 && i < height)
                if(j > 0 && j < width)
                    Depth(i,j) = LWidth*dDV/255;
                end
            end
        end
        
        i = round(JX2);
        for j = round(JY2):1:width
             if(i > 0 && i < height)
                if(j > 0 && j < width)
                    Depth(i,j) = LWidth*dDV/255;
                end
            end
        end
        
    end
    
    
    
    
else % if(abs(pi/2 - a3) < pi/4)


    TX1 = height;
    TY1 = k3*TX1 + b3;

    TX2 = (width - b3)/k3;
    TY2 = width;

    D1 = sqrt((BeginX - TX1)^2 + (BeginY - TY1)^2);
    D2 = sqrt((BeginX - TX2)^2 + (BeginY - TY2)^2);

    if(D1 > D2)
        EndX = TX1;
        EndY = TY1;
    else
        EndX = TX2;
        EndY = TY2;
    end

    WidthMax = sqrt((BeginX - EndX)^2 + (BeginY - EndY)^2);

    %单位深度得亮度值
    dDV = 255/WidthMax;


    %绘制深度图
    for j = round(BeginY):round(EndY)

        y = j;
        x = round((y - b3)/k3);

        LWidth = sqrt((BeginX - x)^2 + (BeginY - y)^2);

        %填充X轴方向深度
        for i = 1:x
            if(i > 0 && i < height)
                if(j > 0 && j < width)
                    Depth(i,j) = LWidth*dDV/255;
                end
            end
        end

        %填充X轴方向深度
        for j = 1:y
            if(x > 0 && x < height)
                if(j > 0 && j < width)
                    Depth(x,j) = LWidth*dDV/255;
                end
            end
        end

   end

end %if(abs(pi/2 - a3) < pi/4)

figure,imshow(Depth);title('深度图');

