cat = imread('cat_2.jpg');
[height,width,path] = size(cat);
shrink_x = 1 / 3;
shrink_y = 1 / 3;
result = zeros(height,width,path);
tras = [1 / shrink_x 0 0;0 1 / shrink_y 0;0 0 1];

 for i = 1:height
    for j = 1:width
        temp = [i;j;1];
        temp = tras * temp;
        x = uint16(temp(1,1));
        y = uint16(temp(2,1));
        if (x <= height) && (y <= width) && (x >= 1) && (y >=1)
            result(i,j,1) = cat(x,y,1);
            result(i,j,2) = cat(x,y,2);
            result(i,j,3) = cat(x,y,3);
        end
    end
 end
 
 imshow(uint8(result));
 imwrite(uint8(result),'shrink_1_3.jpg');