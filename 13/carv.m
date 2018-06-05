function [Ic, T, rmIdxs, rmIdxs0] = carv(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
% Memory saving way for carving
DEBUG = 0;
[nx, ny, nz] = size(I);
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
rmIdxs = cell(nr+1,nc+1);
pI = zeros(nr+1,nc+1);

TI{1,1} = I;
% remove the horizontal seams
rmHors = [];
for i = 2 : nr+1
    % generate the energy map
	e = genEngMap(TI{i-1, 1});

    % dynamic programming matrix
    [My, Tby] = cumMinEngHor(e);
    [TI{i, 1}, E, rmIdxs{i,1}] = rmHorSeam(TI{i-1, 1}, My, Tby);
    
    % accumulate the energy
	T(i, 1) = T(i-1, 1) + E;
    
    % assign the direction of parent 0 row,1 col
    pI(i,1) = 1;
end

% remove the vertical seams
rmVers = [];
for i = 2 : nc+1
	e = genEngMap(TI{1, i-1});
	[Mx,Tbx] = cumMinEngVer(e);
	[TI{1, i}, E, rmIdxs{1,i}] = rmVerSeam(TI{1, i-1}, Mx, Tbx);
    if(DEBUG)
        [yy,xx] = ind2sub([size(TI{1, i-1},1),size(TI{1, i-1},2)],rmIdxs{1,i});
        yy = unique(yy);
        disp(length(yy));
    end;
	T(1, i) = T(1, i-1) + E;  
    pI(1,i) = 0;
end

% do the dynamic programming
for i = 2 : nr+1
	for j = 2 : nc+1
		e = genEngMap(TI{i-1, j});
		[My, Tby] = cumMinEngHor(e);
		[Iy, Ey, rmHor] = rmHorSeam(TI{i-1, j}, My, Tby);
		
		e = genEngMap(TI{i, j-1});
		[Mx, Tbx] = cumMinEngVer(e);
		[Ix, Ex, rmVer] = rmVerSeam(TI{i, j-1}, Mx, Tbx);
		
		if T(i, j-1) + Ex < T(i-1, j) + Ey
			TI{i, j} = Ix;
			T(i ,j) = T(i, j-1) + Ex;
            rmIdxs{i, j} = rmVer;
            pI(i,j) = 0; % inherite from row direction
		else
			TI{i, j} = Iy;
			T(i, j) = T(i-1, j) + Ey;
            rmIdxs{i,j} = rmHor;
            pI(i,j) = 1; % inherite from col direction
        end
        
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];
	end
end	

%%
% resolving the pathes
optPath = sub2ind([nr+1,nc+1],nr+1,nc+1);
rcur = nr+1; ccur = nc+1; num = nr+nc+1;
while(1)
    if(rcur==1 && ccur==1) break; end; % to the top-left corner
    
    % resolve the path
    num = num - 1;
    if(pI(rcur,ccur)==0) 
        ccur = ccur-1;
        optPath = cat(1,sub2ind([nr+1,nc+1],rcur,ccur),optPath);
    elseif pI(rcur,ccur) == 1;
        rcur = rcur-1;
        optPath = cat(1,sub2ind([nr+1,nc+1],rcur,ccur),optPath);
    else
        error('Undefined symbol for the direction!');
    end;
end;

%%
% checking carving along the path
rmIdxs0 = cell(nc+nr,1);
idxs4Im = reshape(1:size(I,1)*size(I,2),[size(I,1),size(I,2)]);
szP = size(I); % initialize the size of the Image;
for i = 2 : nr+nc+1
    % get the szP
    
    % get the index of the shrink point
    [yy,xx] = ind2sub(szP(1:2),rmIdxs{optPath(i)});
    szC = szP;

    
    % check whether the pI is correct
    if(pI(optPath(i))==0)
        szC(2)  = szC(2) - 1;
        idxs4ImC = zeros(szC(1:2));
        singlePath = [];
        for j = 1 : szC(1)
            singlePath = cat(1,singlePath,idxs4Im(j,xx(j)));
            idxs4ImC(j,:) = cat(2, idxs4Im(j, 1:xx(j)-1), idxs4Im(j, xx(j)+1:end));
        end  
    else
        szC(1) = szC(1) - 1;
        idxs4ImC = zeros(szC(1:2));
        singlePath = [];
        for j = 1 : szC(2)
            singlePath = cat(1,singlePath,idxs4Im(yy(j),j));
            idxs4ImC(:,j) = cat(1, idxs4Im(1:yy(j)-1,j), idxs4Im(yy(j)+1:end,j));            
        end  
    end;
    
    % save the path and reset the residual pixels
    rmIdxs0{i-1} = singlePath;
    idxs4Im = idxs4ImC;    
    szP = szC;
end;



%%

% optPath = sub2ind([nr+1,nc+1],nr+1,nc+1);
% rcur = nr+1; ccur = nc+1; num = nr+nc+1;
% while(1)
%     if(rcur==1 && ccur==1) break; end; % to the top-left corner
%     
%     % resolve the path
%     num = num - 1;
%     szPath{num} = szPath{num+1};
%     if(pI(rcur,ccur)==0) 
%         ccur = ccur-1;
%         szPath{num}(2) = szPath{num}(2) + 1;
%     elseif pI(rcur,ccur) == 1;
%         rcur = rcur-1;
%         szPath{num}(1) = szPath{num}(1) + 1;
%     else
%         error('Undefined symbol for the direction!');
%     end;
%     
%     rmPath{num} = rmIdxs{rcur,ccur};
% end;

% rmPath = cell(nr+nc+1,1); rmPath{end} = rmIdxs{end,end};
% szPath = cell(nr+nc+1,1); szPath{end} = [size(TI{nr+1,nc+1},1),size(TI{nr+1,nc+1},2)];
% idxs4Im = reshape(1:size(I,1)*size(I,2),[size(I,1),size(I,2)]);

% if(num~=1)
%     error('Num should reach the end of the matrix');
% end;
% 
% if(szPath{1}(1)~=size(I,1) || szPath{1}(2)~=size(I,2))
%     error('Check the size of the image');
% end;
% 
% % resolving according to the original path
% idxs0 = idxs4Im;
% rmIdxs0 = cell(nc+nr,1);
% for i = 2 : nc+nr+1
%     rmIdxs0{i-1} = idxs0(rmPath{i});
%     if(DEBUG)
%         [yy,xx] = ind2sub(szPath{i},rmPath{i});
%         disp(length(unique(yy)));
%     end;
%     
%     if(szPath{i}(1)==szPath{i-1}(1))
%         [yy,xx] = ind2sub(szPath{i-1},rmPath{i});
%         xxRot = yy; yyRot = xx;
%         indRot = sub2ind([szPath{i-1}(2),szPath{i-1}(1)],yyRot,xxRot);
%         idxs0 = idxs0';
%         idxs0(indRot) = [];
%         idxs0 = reshape(idxs0,[szPath{i}(2) szPath{i}(1)]);
%         idxs0 = idxs0';
%  
%         if(DEBUG)
%         [yy,xx] = ind2sub(szPath{i},idxs0);
%         figure(22);subplot(1,2,1);imagesc(xx);
%                subplot(1,2,2);imagesc(yy);
%         end;
%     else
%         idxs0(rmPath{i}) = [];
%     end;
% end;

% get the final image
Ic = TI{nr+1,nc+1};

end