clc;clear;
% demo_fourier transform
% construct a 11x11 averaging template
% x方向的运动模糊
f2 = [zeros(5,11); 1/11*ones(1,11); zeros(5,11)];
% for i = 1 : 11
%     f2(i,6) = 1 / 11;
% end
% for i = 1 : 11
%     f2(i,i) = 1 / 11;
%     f2(i,12 -i) = 1/11;
% end
%  do the 2d Fourier transform
% F2 = fft2(f2);

% construct a 11x11 impluse template
% 冲激响应
f1 =zeros(11,11);
f1(6,6) = 5;
%  do the 2d Fourier transform
% F1 = fft2(f1);

%%
% 1-1）尝试分析F1，F2，F1-F2的频谱信息
% 1-2）是否和我们先前讲解的例子对应上，你找自己拍摄的一幅照片，缩小成256x256，利用f1,f2,f1-f2进行卷积，观察得到的图像特性？
% 1-3）如果频谱信息和我们所说的对应不上，为什么？
cat = imread('black_white.jpg');
cat=rgb2gray(cat);
% cat_f1_res = filter2(f1,cat,'same');
% cat_f2_res = filter2(f2,cat,'same');
% cat_f1_f2_res = filter2(f1 - f2,cat,'same');
% cat_f1_res = uint8(cat_f1_res);
% cat_f2_res = uint8(cat_f2_res);
% cat_f1_f2_res = uint8(cat_f1_f2_res);
% figure(1);imshow(cat);
% figure(2);imshow(cat_f1_res);
% figure(3);imshow(cat_f2_res);
% figure(4);imshow(cat_f1_f2_res);
% figure(5),subplot(2,2,2),imshow(F1,[]),title('f1二维傅里叶变换');
% figure(5),subplot(2,2,3),imshow(F2,[]),title('f2二维傅里叶变换');
% figure(5),subplot(2,2,4),imshow(fft2(f1 - f2),[]),title('f1 - f2二维傅里叶变换');

%%
% 2-1）尝试利用离散余弦变换分析f1，f2，f1-f2的频谱信息
% 2-2）如果频谱信息和我们所说的对应不上，为什么？
F1_DCT = dct2(cat);
figure(6),subplot(2,2,1),imshow(log(abs(F1_DCT)),[]),title('f1二维DCT变换');
F2_DCT = dct2(f2);
figure(6),subplot(2,2,2),imshow(F2_DCT,[]),title('f2二维DCT变换');
F1_F2_DCT = dct2(f1 - f2);
figure(6),subplot(2,2,3),imshow(F1_F2_DCT,[]),title('f1 - f2二维DCT变换');