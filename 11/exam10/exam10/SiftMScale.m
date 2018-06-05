function [pos,scale,orient,desc] = SiftMScale(im,octaves, intervals)
    pos = [];
    orient = [];
    scale = [];
    desc = [];
    for octave = 1:octaves
        [temp_pos,temp_scale,temp_orient,temp_desc] = Sift1Scale(im,intervals);
        pos = [pos;temp_pos];
        scale = [scale;temp_scale];
        orient = [orient;temp_orient];
        desc = [desc;temp_desc];
%         sigma = sqrt(2)^2;
%         g = gaussian_filter(sigma);
%         im = conv2(g,g,im,'same');
        sz = size(im);
        [X,Y] = meshgrid( 1:2:sz(2), 1:2:sz(1) );
        im = interp2(im,X,Y,'*nearest');
    end
end

