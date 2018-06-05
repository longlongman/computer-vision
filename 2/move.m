cat = imread('cat_2.jpg');
[height,width,path] = size(cat);
delx = 50;
dely = 50;

result = zeros(height,width,path);
tras = [1 0 delx;0 1 dely;0 0 1];

 for i = 1:height
    for j = 1:width
        temp = [i;j;1];
        temp = tras * temp;
        x = temp(1,1);
        y = temp(2,1);
        if (x <= height) && (y <= width) && (x >= 1) && (y >=1)
            result(i,j,1) = cat(x,y,1);
            result(i,j,2) = cat(x,y,2);
            result(i,j,3) = cat(x,y,3);
        end
    end
 end
 
 imshow(uint8(result));
 imwrite(uint8(result),'move_3.jpg');