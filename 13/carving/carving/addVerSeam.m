function [Ix, E] = addVerSeam(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal
[ny, nx, nz] = size(I);
Ix = uint8(zeros(ny, nx + 1, nz));
[val,index] = min(Mx(end,:));
E = val;
for i = ny :-1 :2
    Ix(i,1:index,:) = I(i,1:index,:);
    Ix(i,index + 1,:) = I(i,index,:);
    Ix(i,index + 2:end,:) = I(i,index + 1:end,:);
    if Tbx(i,index) == -1
        index = index - 1;
    elseif Tbx(i,index) == 1
        index = index + 1;
    end
end

Ix(1,1:index,:) = I(1,1:index,:);
Ix(1,index + 1,:) = I(1,index,:);
Ix(1,index + 2:end,:) = I(1,index + 1:end,:);

end

