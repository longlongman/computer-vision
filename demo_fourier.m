clc;clear;
% demo_fourier transform
% construct a 11x11 averaging template
% x������˶�ģ��
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
% �弤��Ӧ
f1 =zeros(11,11);
f1(6,6) = 5;
%  do the 2d Fourier transform
% F1 = fft2(f1);

%%
% 1-1�����Է���F1��F2��F1-F2��Ƶ����Ϣ
% 1-2���Ƿ��������ǰ��������Ӷ�Ӧ�ϣ������Լ������һ����Ƭ����С��256x256������f1,f2,f1-f2���о�����۲�õ���ͼ�����ԣ�
% 1-3�����Ƶ����Ϣ��������˵�Ķ�Ӧ���ϣ�Ϊʲô��
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
% figure(5),subplot(2,2,2),imshow(F1,[]),title('f1��ά����Ҷ�任');
% figure(5),subplot(2,2,3),imshow(F2,[]),title('f2��ά����Ҷ�任');
% figure(5),subplot(2,2,4),imshow(fft2(f1 - f2),[]),title('f1 - f2��ά����Ҷ�任');

%%
% 2-1������������ɢ���ұ任����f1��f2��f1-f2��Ƶ����Ϣ
% 2-2�����Ƶ����Ϣ��������˵�Ķ�Ӧ���ϣ�Ϊʲô��
F1_DCT = dct2(cat);
figure(6),subplot(2,2,1),imshow(log(abs(F1_DCT)),[]),title('f1��άDCT�任');
F2_DCT = dct2(f2);
figure(6),subplot(2,2,2),imshow(F2_DCT,[]),title('f2��άDCT�任');
F1_F2_DCT = dct2(f1 - f2);
figure(6),subplot(2,2,3),imshow(F1_F2_DCT,[]),title('f1 - f2��άDCT�任');