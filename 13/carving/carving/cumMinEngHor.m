function [My, Tby] = cumMinEngHor(e)
% e is the energy map.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.

[ny,nx] = size(e);
My = zeros(ny, nx);
Tby = zeros(ny, nx);
My(:,1) = e(:,1);

%% Add your code here
for i = 2 : nx
    for j = 1 : ny
        if j == 1
            [val,index] = min([My(j,i -1) My(j + 1,i - 1)]);
            My(j,i)= e(j,i) + val; 
            index = index - 1;
            Tby(j,i) = index;
        elseif j == ny
            [val,index] = min([My(j - 1,i - 1) My(j,i -1)]);
            My(j,i)= e(j,i) + val; 
            index = index - 2;
            Tby(j,i) = index;
        else
            [val,index] = min([My(j - 1,i - 1) My(j,i -1) My(j + 1,i - 1)]);
            My(j,i)= e(j,i) + val; 
            index = index - 2;
            Tby(j,i) = index;
        end
    end
end

end