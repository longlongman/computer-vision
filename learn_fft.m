clc;clear;
% I = imread('lena.jpg');
% I = I(:,:,1);
I = [zeros(5,11); 1/11*ones(1,11); zeros(5,11)];
for i = 1 : 11
    I(i,6) = 1 / 11;
end
% for i = 1 : 11
%     I(i,i) = 1 / 11;
%     I(i,12 -i) = 1/11;
% end
 
% I =zeros(11,11);
% I(6,6) = 2;

% I =zeros(11,11);
% I(6,6) = 2;
% I = I - [zeros(5,11); 1/11*ones(1,11); zeros(5,11)];

fI = fft2(I);  
sfI = fftshift(fI);  
temp = log(1+abs(sfI));  
  
subplot(2,2,1),imshow(I,[]),title('ԭͼ');  
subplot(2,2,2),imshow(abs(fI),[]),title('��ά����Ҷ�任');  
subplot(2,2,3),imshow(abs(sfI),[]),title('�Գ��ƶ�ͼ��Ƶ��');
subplot(2,2,4),imshow(temp,[]),title('�����任���Ƶ��');  
 