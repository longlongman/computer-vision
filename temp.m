clear;clc;
f1 =zeros(11,11);
f1(6,6) = 5;
f2 = [zeros(5,11); 1/11*ones(1,11); zeros(5,11)];
for i = 1 : 11
    f2(i,6) = 1 / 11;
end
for i = 1 : 11
    f2(i,i) = 1 / 11;
    f2(i,12 -i) = 1/11;
end
cat = imread('cat_2.jpg');
cat = cat(:,:,1);
cat_f1_res = filter2(f1,cat,'same');
cat_f2_res = filter2(f2,cat,'same');
cat_f1_f2_res = filter2(f1 - f2,cat,'same');

cat = fft2(cat);
cat = fftshift(cat);
cat = log(1+abs(cat));

cat_f1_res = fft2(cat_f1_res);
cat_f1_res = fftshift(cat_f1_res);
cat_f1_res = log(1+abs(cat_f1_res));

cat_f2_res = fft2(cat_f2_res);
cat_f2_res = fftshift(cat_f2_res);
cat_f2_res = log(1+abs(cat_f2_res));

cat_f1_f2_res = fft2(cat_f1_f2_res);
cat_f1_f2_res = fftshift(cat_f1_f2_res);
cat_f1_f2_res = log(1+abs(cat_f1_f2_res));

subplot(2,2,1),imshow(cat,[]),title('ԭͼ');  
subplot(2,2,2),imshow(cat_f1_res,[]),title('after f1'); 
subplot(2,2,3),imshow(cat_f2_res,[]),title('after f2');
subplot(2,2,4),imshow(cat_f1_f2_res,[]),title('after f1 - f2');  