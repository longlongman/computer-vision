function [Iy, E,rmIdx] = rmHorSeam(I, My, Tby)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image removed one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(1, nx);
Iy = uint8(zeros(ny-1, nx, nz));

%% Add your code here
[val,index] = min(My(:,end));
E = val;
for i = nx :-1 :2
    Iy(1:index - 1,i,:) = I(1:index - 1,i,:);
    Iy(index:end,i,:) = I(index + 1:end,i,:);
    rmIdx(1,i) = index;
    if Tby(index,i) == -1
        index = index - 1;
    elseif Tby(index,i) == 1
        index = index + 1;
    end
end

Iy(1:index - 1,1,:) = I(1:index - 1,1,:);
Iy(index:end,1,:) = I(index + 1:end,1,:);
rmIdx(1,1) = index;

end