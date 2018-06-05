
function outputIm = backward_geometry(inputIm, A,type)
% inputIm = 输入的图像
%       A = 仿射变换的系数，一个2x3的矩阵


% 获取输入图像的大小
inputSize = size(inputIm);
if(size(inputIm, 3) == 1)
   inputSize(3) = 1; 
end
%imshow(inputIm);
% 计算输出图像的画布大小
[outputSize, deltaShift] = calcOutputSize(inputSize, A,type);
%A_inv = [(1/(A(1,1)*A(2,2)/A(1,2) - A(2,1))) 0;0 (1/(A(2,2)*A(1,1)/A(2,1) - A(1,2)))]* [(A(2,2)/A(1,2)) -1;-1 (A(1,1)/A(2,1))] * [1 0 -A(1,3);0 1 -A(2,3)]; 
A_inv = A(1:2,1:2);
B = A(:,3);
outputIm = zeros(outputSize(1),outputSize(2),3);

% 根据确定的输出画布大小来进行遍历
for i = 1 : outputSize(1)
    for j = 1 : outputSize(2)
        y = j + deltaShift(2);
        x = i + deltaShift(1);
        
        % 进行逆向变换，计算当前点(x,y)在输入图像中的坐标
        z = A_inv \ ([x;y] - B);
        %z = round(z);
        z_floor = floor(z);
        delta = z - z_floor; 
        w00 = (1 - delta(1)) * (1 - delta(2));
        w01 = delta(1) * (1 - delta(2));
        w10 = (1 - delta(1)) * delta(2);
        w11 = delta(1) * delta(2);
        % 进行双线性插值获取像素点的值
        if z_floor(1) >= 1 && z_floor(1) + 1 <= inputSize(2) && z_floor(2) >= 1 && z_floor(2) + 1 <= inputSize(1)
            outputIm(i,j,1) = w00 * inputIm(z_floor(2),z_floor(1),1) + w01 * inputIm(z_floor(2) + 1,z_floor(1),1) + w10 * inputIm(z_floor(2),z_floor(1) + 1,1) + w11 * inputIm(z_floor(2) + 1,z_floor(1) + 1,1);
            outputIm(i,j,2) = w00 * inputIm(z_floor(2),z_floor(1),2) + w01 * inputIm(z_floor(2) + 1,z_floor(1),2) + w10 * inputIm(z_floor(2),z_floor(1) + 1,2) + w11 * inputIm(z_floor(2) + 1,z_floor(1) + 1,2);
            outputIm(i,j,3) = w00 * inputIm(z_floor(2),z_floor(1),3) + w01 * inputIm(z_floor(2) + 1,z_floor(1),3) + w10 * inputIm(z_floor(2),z_floor(1) + 1,3) + w11 * inputIm(z_floor(2) + 1,z_floor(1) + 1,3);
            %outputIm(i,j,2) = inputIm(z(2),z(1),2);
            %outputIm(i,j,3) = inputIm(z(2),z(1),3);
        end
    end
end
outputIm = uint8(outputIm);
end


function [outputSize, deltaShift] = calcOutputSize(inputSize, A,type)
% type 有两种，一种是 loose， 一种是crop，参考imrotate命令的帮助文件
% 需要实现这两种
% 'crop'
% Make output image B the same size as the input image A, cropping the rotated image to fit
% {'loose'}
% Make output image B large enough to contain the entire rotated image. B is larger than A


% 获取图像的行和列的总数，其中行方向对应着y方向，列方向对应着x方向    
ny = inputSize(1);
nx = inputSize(2);

% 计算四个顶点的齐次坐标
inputBoundingBox = [ 1  1 1;...
                    nx  1 1;...
                    nx ny 1;...
                     1 ny 1];
inputBoundingBox = inputBoundingBox';

% 获取输入图像经过仿射变换后在输出图像中的框
outputBoundingBox = A * inputBoundingBox;

% 找到输出图像的紧致的框
xlo = floor(min(outputBoundingBox(1,:)));
xhi =  ceil(max(outputBoundingBox(1,:)));
ylo = floor(min(outputBoundingBox(2,:)));
yhi =  ceil(max(outputBoundingBox(2,:)));


% 重新设置画布大小， 需要你们自己添加
if strcmpi(type,'loose')
    outputSize(1) = xhi - xlo;
    outputSize(2) = yhi - ylo;
else
    outputSize(1) = nx;
    outputSize(2) = ny;
end
% 根据重新设置的画布大小，计算你们需要添加的偏移量deltaShift，自己添加
if strcmpi(type,'loose')
    deltaShift(1) = xlo - 1;
    deltaShift(2) = ylo - 1;
else
    deltaShift(1) = 0;
    deltaShift(2) = 0;
end
end