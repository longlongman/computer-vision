function [Ic, T] = carv_with_mask(I, nr, nc,mask,r_s)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
% mask is where you want to remove or save
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
TI{1,1} = I;
Masks = cell(nr + 1,nc + 1);
Masks{1,1} = mask;

if ~exist('r_s','var')
    r_s = 1;
end

%% Add your code here
% remove the horizontal seams
for i = 2 : nr + 1
    %generate the energy map
    e = genEngMap(TI{i - 1,1});
    if r_s == 1
        e = e - e .* Masks{i - 1,1}; 
    elseif r_s == 0
        e = e - e .* Masks{i - 1,1} + 255 * Masks{i - 1,1};
    end
    %dynamic programming matrix
    [My,Tby] = cumMinEngHor(e);
    [TI{i, 1}, E,~,Masks{i,1}] = rmHorSeam_with_mask(TI{i-1, 1}, My, Tby,Masks{i - 1,1});

    %accumulate the energy
    T(i,1) = T(i - 1,1) + E;
end


% remove the vertical seams
for i = 2 : nc+1
	e = genEngMap(TI{1, i-1});
    if r_s == 1
        e = e - e .* Masks{1,i - 1}; 
    elseif r_s == 0
        e = e - e .* Masks{1,i - 1} + 255 * Masks{1,i - 1};
    end
	[Mx,Tbx] = cumMinEngVer(e);
	[TI{1, i}, E,~,Masks{1,i}] = rmVerSeam_with_mask(TI{1, i-1}, Mx, Tbx,Masks{1,i - 1});
	T(1, i) = T(1, i-1) + E;
end

% do the dynamic programming
for i = 2 : nr+1
    for j = 2 : nc+1
        e = genEngMap(TI{i-1, j});
        if r_s == 1
            e = e - e .* Masks{i - 1,j}; 
        elseif r_s == 0
            e = e - e .* Masks{i - 1,j} + 255 * Masks{i - 1,j};
        end
        [My, Tby] = cumMinEngHor(e);
        [Iy, Ey,~,mask_y] = rmHorSeam_with_mask(TI{i-1, j}, My, Tby,Masks{i - 1,j});
        
        e = genEngMap(TI{i, j-1});
        if r_s == 1
            e = e - e .* Masks{i,j - 1}; 
        elseif r_s == 0
            e = e - e .* Masks{i,j - 1} + 255 * Masks{i,j - 1};
        end
        [Mx, Tbx] = cumMinEngVer(e);
        [Ix, Ex,~,mask_x] = rmVerSeam_with_mask(TI{i, j-1}, Mx, Tbx,Masks{i,j - 1});
        if T(i, j-1) + Ex < T(i-1, j) + Ey
            TI{i, j} = Ix;
            T(i ,j) = T(i, j-1) + Ex;
            Masks{i,j} = mask_x;
            % inherite from row direction
        else
            TI{i, j} = Iy;
            T(i, j) = T(i-1, j) + Ey;
            Masks{i,j} = mask_y;
            % inherite from col direction
        end
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];
        Masks{i - 1,j} = [];
	end
end

Ic = TI{nr+1,nc+1};

end

