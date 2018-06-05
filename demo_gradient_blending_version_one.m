%% 清空工作区和命令行窗口
clc;clear;

%% 读入两幅图像，一幅是background，另一幅是target图像，利用Matlab的roipoly函数标记target一个多边形的区域
background = imread('apple.jpg');
background_size = size(background);
target = imread('cat_2.jpg');
target_size = size(target);
% 利用roipoly从target图片中选择感兴趣区域
handler = figure(1);
[BW, xi, yi] = roipoly(target);
save('target.mat','BW','xi','yi');
close(handler);

% target_mask = load('target.mat', 'BW');
% target_mask = target_mask.BW;
% figure;imshow(background,[]);
% figure;imshow(target,[]);
% figure;imshow(target_mask,[])

%% 获取background中想要进行blend的位置
handler = figure(1);
imshow(background);
[xshift,yshift] = ginput(1);
close(handler);
% 至此用户输入完毕

%% 对target图像做拉普拉斯算子卷积
laplacian_cal = [0 -1 0;-1 4 -1;0 -1 0];
target_mask = load('target.mat', 'BW');
target_mask = target_mask.BW;
target_gradient = zeros(target_size(1),target_size(2),target_size(3));
for path_con = 1 : target_size(3)
    target_gradient(:,:,path_con) = target_mask .* conv2(target(:,:,path_con),laplacian_cal,'same');
end
% imshow(target_gradient);

%% 对选中部分的像素标号
target_label = zeros(target_size(1),target_size(2));
target_mask_size = size(target_mask);
con = 1;
for row_con = 1 : target_mask_size(1)
    for col_con = 1 : target_mask_size(2)
        if target_mask(row_con,col_con) == 1
            target_label(row_con,col_con) = con;
            con = con + 1;
        end
    end
end
% imshow(target_label,[]);

%% 构造矩阵A和b
dim = con - 1;
neber = [-1 0;0 1;1 0;0 -1];
f = zeros(dim,1,3);
for path_con = 1 : 3
A = zeros(dim,dim);
b = zeros(dim,1);
cur = 0;
for row_con = 1 : target_mask_size(1)
    for col_con = 1 : target_mask_size(2)
        if target_mask(row_con,col_con) == 1
            cur = cur + 1;
            for neber_con = 1 : 4
                if target_mask(row_con - neber(neber_con,1),col_con - neber(neber_con,2)) == 1
                    A(cur,target_label(row_con - neber(neber_con,1),col_con - neber(neber_con,2))) = -1;
                else
                    b(cur,1) = b(cur,1) + background(round(yshift - target_mask_size(1) / 2) + row_con - 1,round(xshift - target_mask_size(2) / 2) + col_con - 1,path_con);
                end
            end
            b(cur,1) = b(cur,1) + target_gradient(row_con,col_con,1);
            A(cur,cur) = 4;
        end
    end
end
f(:,:,path_con) = A \ b;
end


%% 还原图像
target_res = zeros(target_mask_size(1),target_mask_size(2),3);
for row_con = 1 : target_mask_size(1)
    for col_con = 1 : target_mask_size(2)
        if target_mask(row_con,col_con) == 1
            target_res(row_con,col_con,1) = round(f(target_label(row_con,col_con),1,1));
            target_res(row_con,col_con,2) = round(f(target_label(row_con,col_con),1,2));
            target_res(row_con,col_con,3) = round(f(target_label(row_con,col_con),1,3));
        end
    end
end