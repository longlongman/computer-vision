
function outputIm = backward_geometry(inputIm, A,type)
% inputIm = �����ͼ��
%       A = ����任��ϵ����һ��2x3�ľ���


% ��ȡ����ͼ��Ĵ�С
inputSize = size(inputIm);
if(size(inputIm, 3) == 1)
   inputSize(3) = 1; 
end
%imshow(inputIm);
% �������ͼ��Ļ�����С
[outputSize, deltaShift] = calcOutputSize(inputSize, A,type);
%A_inv = [(1/(A(1,1)*A(2,2)/A(1,2) - A(2,1))) 0;0 (1/(A(2,2)*A(1,1)/A(2,1) - A(1,2)))]* [(A(2,2)/A(1,2)) -1;-1 (A(1,1)/A(2,1))] * [1 0 -A(1,3);0 1 -A(2,3)]; 
A_inv = A(1:2,1:2);
B = A(:,3);
outputIm = zeros(outputSize(1),outputSize(2),3);

% ����ȷ�������������С�����б���
for i = 1 : outputSize(1)
    for j = 1 : outputSize(2)
        y = j + deltaShift(2);
        x = i + deltaShift(1);
        
        % ��������任�����㵱ǰ��(x,y)������ͼ���е�����
        z = A_inv \ ([x;y] - B);
        %z = round(z);
        z_floor = floor(z);
        delta = z - z_floor; 
        w00 = (1 - delta(1)) * (1 - delta(2));
        w01 = delta(1) * (1 - delta(2));
        w10 = (1 - delta(1)) * delta(2);
        w11 = delta(1) * delta(2);
        % ����˫���Բ�ֵ��ȡ���ص��ֵ
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
% type �����֣�һ���� loose�� һ����crop���ο�imrotate����İ����ļ�
% ��Ҫʵ��������
% 'crop'
% Make output image B the same size as the input image A, cropping the rotated image to fit
% {'loose'}
% Make output image B large enough to contain the entire rotated image. B is larger than A


% ��ȡͼ����к��е������������з����Ӧ��y�����з����Ӧ��x����    
ny = inputSize(1);
nx = inputSize(2);

% �����ĸ�������������
inputBoundingBox = [ 1  1 1;...
                    nx  1 1;...
                    nx ny 1;...
                     1 ny 1];
inputBoundingBox = inputBoundingBox';

% ��ȡ����ͼ�񾭹�����任�������ͼ���еĿ�
outputBoundingBox = A * inputBoundingBox;

% �ҵ����ͼ��Ľ��µĿ�
xlo = floor(min(outputBoundingBox(1,:)));
xhi =  ceil(max(outputBoundingBox(1,:)));
ylo = floor(min(outputBoundingBox(2,:)));
yhi =  ceil(max(outputBoundingBox(2,:)));


% �������û�����С�� ��Ҫ�����Լ����
if strcmpi(type,'loose')
    outputSize(1) = xhi - xlo;
    outputSize(2) = yhi - ylo;
else
    outputSize(1) = nx;
    outputSize(2) = ny;
end
% �����������õĻ�����С������������Ҫ��ӵ�ƫ����deltaShift���Լ����
if strcmpi(type,'loose')
    deltaShift(1) = xlo - 1;
    deltaShift(2) = ylo - 1;
else
    deltaShift(1) = 0;
    deltaShift(2) = 0;
end
end