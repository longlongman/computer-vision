
% ����һ��ͼ������Matlab��roipoly�������һ������ε�����
im1 = imread('E.jpg'); 


% ����roipoly��ͼƬ1��ѡ�����Ȥ����
figure(1);clf; %imshow(im1);
[BW, xi, yi] = roipoly(im1);
save('target.mat','BW','xi','yi');