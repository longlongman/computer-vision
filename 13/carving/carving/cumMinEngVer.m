function [Mx, Tbx] = cumMinEngVer(e)
% e is the energy map.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.

[ny,nx] = size(e);
Mx = zeros(ny, nx);
Tbx = zeros(ny, nx);
Mx(1,:) = e(1,:);

%% Add your code here
for j = 2 : ny
    for i = 1 : nx
        if i == 1
            [val,index] = min([Mx(j - 1,i) Mx(j - 1,i + 1)]);
            Mx(j,i)= e(j,i) + val; 
            index = index - 1;
            Tbx(j,i) = index;
        elseif i == nx
            [val,index] = min([Mx(j - 1,i - 1) Mx(j - 1,i)]);
            Mx(j,i)= e(j,i) + val; 
            index = index - 2;
            Tbx(j,i) = index;
        else
            [val,index] = min([Mx(j - 1,i - 1) Mx(j - 1,i) Mx(j - 1,i + 1)]);
            Mx(j,i)= e(j,i) + val; 
            index = index - 2;
            Tbx(j,i) = index;
        end
    end
end

end