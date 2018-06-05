function [Ix, E,rmIdx] = rmVerSeam(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(ny, 1);
Ix = uint8(zeros(ny, nx-1, nz));

%% Add your code here
[val,index] = min(Mx(end,:));
E = val;
for i = ny :-1 :2
    Ix(i,1:index - 1,:) = I(i,1:index - 1,:);
    Ix(i,index:end,:) = I(i,index + 1:end,:);
    rmIdx(i,1) = index;
    if Tbx(i,index) == -1
        index = index - 1;
    elseif Tbx(i,index) == 1
        index = index + 1;
    end
end

Ix(1,1:index - 1,:) = I(1,1:index - 1,:);
Ix(1,index:end,:) = I(1,index + 1:end,:);
rmIdx(1,1) = index;

end