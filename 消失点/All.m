sourcePic=imread('E.jpg');
sourcePic=rgb2gray(sourcePic);

sourcePic=im2double(sourcePic);

%ʹ��ˮƽ�ʹ�ֱSobel����,�Զ�ѡ����ֵ 
edgePic=edge(sourcePic,'sobel','horizontal'); 
figure,imshow(edgePic),title('ˮƽͼ���Ե���'); % ��ʾ��Ե̽��ͼ�� 

edgePic=edge(sourcePic,'sobel','vertical'); 

figure,imshow(edgePic),title('��ֱͼ���Ե���'); % ��ʾ��Ե̽��ͼ�� 

edgePic=edge(sourcePic,'sobel'); 

[height,width]=size(edgePic); 

 %ͼ����ֱ�ߵĸ���
 LINE_COUNT = 100;
 
 % Hough�任���ֱ�ߣ�g(x)=(a,p)Ϊ�߽���Ӧ��ƽ��  
 ma=180; %a��ֵΪ0��180��  

 mp=round(sqrt(height^2+width^2)); %��ӦP�����ֵ  

 npc=zeros(ma,2*mp); %���ڼ�¼(a,p)��Ӧ�ĵ�ĸ���  
 
 MAP=zeros(height, width);
 
 npp=cell(ma,2*mp); %���ڼ�¼(a,p)��Ӧ�ĵ������  
 
 for i=1:height %����(a,p)��ֵ��������Ӧ��¼  

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


LNum = 0;                       %�õ���ֱ�ߵ���Ŀ
LPC = zeros(LINE_COUNT,6);      %ֱ�ߵĲ������� Ԫ��Ϊ [Number][k][b][a][p][DP]   �ֱ�Ϊֱ�ߵ�: ��� б�� �ؾ� �Ƕ�a �ҳ�p �Ƿ�Ϊ��ʧ��
index = 1;


%��ȡֱ�ߵķ�ֵ
LT = 90;

for i=1:ma      

     for j=1:mp*2  

         if(npc(i,j) > LT) 
             
                lk= -cot(pi*i/180);
                lb= round((j - mp - 1)/sin(pi*i/180));

                %����ֱ�ߵĲ�����˳��Ϊ ��� (k,b) (a,p)
                LNum = LNum + 1;
                
                LPC(index,1) = LNum;%�洢ֱ�ߵı��
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

figure,imshow(MAP);title('������ֱ��ͼ');

%����ܹ��ж��ٽ���
InterCount = LNum*(LNum - 1)*0.5;

LInter = zeros(InterCount,4);           %ֱ�ߵĽ��㼯�� Ԫ��Ϊ �����ֱཻ�ߵı�� i,j �� �������� x,y . �� i < j
                                        %Ԫ�ظ���Ϊ n*(n - 1)/2
%����Ĵ�������ֱ�ߵĽ���
T =1;

LIC = 0;                                %ֱ�߽���ĸ���

for i = 1:LNum - 1
    for j = i + 1:LNum
        
        k1 = LPC(i,2);
        b1 = LPC(i,3);

        k2 = LPC(j,2);
        b2 = LPC(j,3);
        
        dp = k1 - k2;                   %�õ�����ֱ��б��֮��
        
        if(abs(dp - 0) > 10e-03)        %���б��֮��̫С���Ϳ�����Ϊ������ֱ��ƽ�ж�û�н��㡣
            
            LIC = LIC + 1;              %ֱ�߽��������һ
            
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
%���µĲ���������ʧ�����ʧ�ߵĲ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TDist = 10;                 %����ķ�ֵ
count = 1;

PANum = zeros(InterCount,1);

for i = 1:LIC - 1
    for j = i + 1:LIC
        
        %������֮��ľ���
        DX = LInter(i,3) - LInter(j,3);
        DY = LInter(i,4) - LInter(j,4);
        
        dist = round(sqrt(DX^2 + DY^2));
        
        %�������С��һ���ķ�ֵ������Ϊ�������ཻ
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


%�õ���ʧ�����ʧ�ߵĲ���
for i=1:LIC
    if(MaxNum == PANum(i,1))
        DispX = DispX + LInter(i,3);
        DispY = DispY + LInter(i,4);
        
        ind1 = LInter(i,1);
        ind2 = LInter(i,2);
        
        LPC(ind1,6) = 1;        %����ֱ��Ϊ��ʧ��
        
        LPC(ind2,6) = 1;        %����ֱ��Ϊ��ʧ��
        count = count + 1;
    end
end


%�����ʧ�������
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

%������ʧ��
for n = 1:LNum
    %������ʧ�ߵĲ������̻�����ʧ��
    if(LPC(n,6) == 1)
        for Y=1:width
                X = round((Y - LPC(n,3))/LPC(n,2));
                if(X > 0 && X < height)
                    PMAP(X + DX, Y + DY) = 1;
                end
        end
    end
end

%������ʧ��
for i = -5:5
    for j = -5:5
        PMAP(round(DispX + DX + i), round(DispY + DY + j)) = 1;
    end
end


figure,imshow(PMAP);title('��ʧ�����ʧ��');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���µĲ����������ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%�������ͼ����
Depth = zeros(height, width);

%��ʧ�߲������� Ԫ��Ϊ[k][b]
PA = zeros(2,2);

%��б����С����ʧ�ߵĲ���
DIST = zeros(LPC,1);

for i = 1:LNum
    DIST(i,1) = LPC(i,2)*height + LPC(i,3);
end

[LIN,index] = min(DIST);
PA(1,1) = LPC(index,2); %ֱ��б��k
PA(1,2) = LPC(index,3); %ֱ�߽ؾ�b

[LOUT,index] = max(DIST);

%��б��������ʧ�ߵĲ���
PA(2,1) = LPC(index,2); %ֱ��б��k
PA(2,2) = LPC(index,3); %ֱ�߽ؾ�b

%У���������ʧ��
BeginX = (PA(2,2) - PA(1,2))/(PA(1,1) - PA(2,1));
BeginY = PA(1,1)*BeginX + PA(1,2);

%��ֱ��l3�ı��ʽ,����ֱ�� l1 l2 �Ľ����ֱ�� l1 l2 �ı��ʽ
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
    
    %��λ��ȵ�����ֵ
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

    %��λ��ȵ�����ֵ
    dDV = 255/WidthMax;


    %�������ͼ
    for j = round(BeginY):round(EndY)

        y = j;
        x = round((y - b3)/k3);

        LWidth = sqrt((BeginX - x)^2 + (BeginY - y)^2);

        %���X�᷽�����
        for i = 1:x
            if(i > 0 && i < height)
                if(j > 0 && j < width)
                    Depth(i,j) = LWidth*dDV/255;
                end
            end
        end

        %���X�᷽�����
        for j = 1:y
            if(x > 0 && x < height)
                if(j > 0 && j < width)
                    Depth(x,j) = LWidth*dDV/255;
                end
            end
        end

   end

end %if(abs(pi/2 - a3) < pi/4)

figure,imshow(Depth);title('���ͼ');

