
% demo the givens decomposition
K = [10 0 10; 0 10 10; 0 0 1];

theta = pi/4;
rz = [-cos(theta); -sin(theta); 0];
ry = [0 0 -1]';
rx = [-sin(theta); cos(theta); 0];
R0 = [rx'; ry'; rz'];

P = K * R0

%%
% decompose for illustration
sols = cell(4,1); 
sols{1} = P; % intialize the solution
rots{1} = eye(3); % intialize the rotation matrix
for i = 1 : 3
    sz = size(sols{i});
    cM = []; cR = [];
    for j = 1 : size(sols{i},3)
        M = squeeze(sols{i}(:,:,j));
        R = squeeze(rots{i}(:,:,j));
        if(i==1)
            c = M(3,2)/(sqrt(M(3,1)^2+M(3,2)^2)+1e-20);
            s = M(3,1)/(sqrt(M(3,1)^2+M(3,2)^2)+1e-20);
            R1 = [c -s 0; s c 0; 0 0 1];
            R2 = [-c s 0; -s -c 0; 0 0 1];
        end
        if(i==2)
            c = M(3,3)/(sqrt(M(3,1)^2+M(3,3)^2)+1e-20);
            s = M(3,1)/(sqrt(M(3,1)^2+M(3,3)^2)+1e-20);
            R1 = [c 0 s; 0 1 0; -s 0 c];
            R2 = [-c 0 -s; 0 1 0; s 0 -c];
        end
        if(i==3)
            c = M(2,2)/(sqrt(M(2,1)^2+M(2,2)^2)+1e-20);
            s = -M(2,1)/(sqrt(M(2,1)^2+M(2,2)^2)+1e-20);
            R1 = [c -s 0; s c 0; 0 0 1];
            R2 = [-c s 0; -s -c 0; 0 0 1];
        end
        if(isempty(cM))
            cM = cat(3, M * R1, M * R2);
            cR = cat(3, R * R1, R * R2);
        else
            cM = cat(3, cM, M * R1, M * R2);
            cR = cat(3, cR, R * R1, R * R2);
        end
    end
    sols{i+1} = cM;
    rots{i+1} = cR;
end

for i = 1 : size(rots{4},3)
   rots{4}(:,:,i) = (rots{4}(:,:,i))';
end

%%
% write your code here, write some checking code to check the validality of
% your QR decomposition