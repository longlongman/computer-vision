for i = 0:0.01:1
     morphed_im = morph(im1, im2, im1_pts, im2_pts, i,i);
     imshow(morphed_im);
     imwrite(morphed_im,[num2str(i) '.jpg']);
end