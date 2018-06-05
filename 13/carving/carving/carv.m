function [Ic, T] = carv(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
TI{1,1} = I;
% TI is a trace table for images. TI{r+1,c+1} records the image removed r rows and c columns.

%% Add your code here

% remove the horizontal seams
for i = 2 : nr + 1
    %generate the energy map
    e = genEngMap(TI{i - 1,1});
    
    %dynamic programming matrix
    [My,Tby] = cumMinEngHor(e);
    [TI{i, 1}, E,~] = rmHorSeam(TI{i-1, 1}, My, Tby);
    
    %accumulate the energy
    T(i,1) = T(i - 1,1) + E;
end

% remove the vertical seams
for i = 2 : nc+1
	e = genEngMap(TI{1, i-1});
	[Mx,Tbx] = cumMinEngVer(e);
	[TI{1, i}, E,~] = rmVerSeam(TI{1, i-1}, Mx, Tbx);
	T(1, i) = T(1, i-1) + E;
end

% do the dynamic programming
for i = 2 : nr+1
    for j = 2 : nc+1
        e = genEngMap(TI{i-1, j});
        [My, Tby] = cumMinEngHor(e);
        [Iy, Ey,~] = rmHorSeam(TI{i-1, j}, My, Tby);
        
        e = genEngMap(TI{i, j-1});
        [Mx, Tbx] = cumMinEngVer(e);
        [Ix, Ex,~] = rmVerSeam(TI{i, j-1}, Mx, Tbx);
        if T(i, j-1) + Ex < T(i-1, j) + Ey
            TI{i, j} = Ix;
            T(i ,j) = T(i, j-1) + Ex; 
            % inherite from row direction
        else
            TI{i, j} = Iy;
            T(i, j) = T(i-1, j) + Ey;
            % inherite from col direction
        end
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];
	end
end

Ic = TI{nr+1,nc+1};

end