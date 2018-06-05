function [Ix, E,rmIdx,return_mask] = rmVerSeam_with_mask(I, Mx, Tbx,mask)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(ny, 1);
Ix = uint8(zeros(ny, nx-1, nz));
return_mask = false(ny,nx - 1);

%% Add your code here
[val,index] = min(Mx(end,:));
E = val;
for i = ny :-1 :2
    Ix(i,1:index - 1,:) = I(i,1:index - 1,:);
    Ix(i,index:end,:) = I(i,index + 1:end,:);
    rmIdx(i,1) = index;
    return_mask(i,1:index - 1) = mask(i,1:index - 1);
    return_mask(i,index:end) = mask(i,index + 1:end);
    if Tbx(i,index) == -1
        index = index - 1;
    elseif Tbx(i,index) == 1
        index = index + 1;
    end
end

Ix(1,1:index - 1,:) = I(1,1:index - 1,:);
Ix(1,index:end,:) = I(1,index + 1:end,:);
rmIdx(1,1) = index;
return_mask(1,1:index - 1) = mask(1,1:index - 1);
return_mask(1,index:end) = mask(1,index + 1:end);
end