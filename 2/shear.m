cat = imread('cat_2.jpg');
[height,width,path] = size(cat);
shx = - 0.5;
yref = -100;
result = zeros(height * 2,width * 2,path);
tras = [1 shx -shx * yref;0 1 0;0 0 1];

 for i = 1:height * 2
    for j = 1:width * 2
        temp = [i;j;1];
        temp = tras * temp;
        x = uint16(temp(1,1));
        y = uint16(temp(2,1));
        if(x <= height)&&(y <= width) && (x >= 1) && (y >=1)
            result(i,j,1) = cat(x,y,1);
            result(i,j,2) = cat(x,y,2);
            result(i,j,3) = cat(x,y,3);
        end
    end
 end
 
 imshow(uint8(result));
 imwrite(uint8(result),'shear.jpg');