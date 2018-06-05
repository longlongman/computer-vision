cat = imread('cat_2.jpg');
[height,width,path] = size(cat);
alfa = -20 * pi / 180.0;
result = zeros(height,width,path);
%变换矩阵
tras = [cos(alfa) -sin(alfa) 0;sin(alfa) cos(alfa) 0;0 0 1];

 for i = 1:height
    for j = 1:width
        temp = [i;j;1];
        %对窗口里每一个坐标点进行变换
        temp = tras * temp;
        x = uint16(temp(1,1));
        y = uint16(temp(2,1));
        if(x <= height)&&(y <= width) && (x >= 1) && (y >=1)
            %给RGB三个通道赋值
            result(x,y,1) = cat(i,j,1);
            result(x,y,2) = cat(i,j,2);
            result(x,y,3) = cat(i,j,3);
        end
    end
 end
 
 imshow(uint8(result));
 imwrite(uint8(result),'spin.jpg');