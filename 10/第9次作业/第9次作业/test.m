clear;clc;
mag = [1 2 3 2 1;
       1 2 3 2 1;
       1 2 3 2 1;
       1 2 3 2 1;
       1 2 3 2 1];
de = [-5/8*pi -7/16*pi -7/16*pi 0 -3/8*pi;
      1/8*pi -3/8*pi 0 0 0;
      -3/16*pi 9/16*pi 5/16*pi -pi -7/8*pi;
      1/2*pi 3/4*pi 3/8*pi 9/16*pi -1/2*pi;
      5/8*pi 13/16*pi -7/16*pi 7/8*pi 7/8*pi];
G = [1 2 3 2 1
     2 4 6 4 2;
     3 6 9 6 3;
     2 4 6 4 2;
     1 2 3 2 1];


num_bins = 16;
step_bin = 2 * pi/num_bins;
bins = -pi : step_bin : pi;
if(length(bins) > num_bins)
    bins = bins(1:end-1);
end

deff = repmat(de(:),[1 num_bins]) - repmat(bins(:)',[25,1]);

deff = 1 - abs(deff)/step_bin;
deff(deff<0) = 0;

wghts = deff .* repmat(G(:).*mag(:), [1 num_bins]);

ohist = sum(wghts,1);