function F = est_optimal_affine(rightpoints,leftpoints)
    A = [rightpoints(1,1) rightpoints(1,2) 1 0 0 0;
         0 0 0 rightpoints(1,1) rightpoints(1,2) 1;
         rightpoints(2,1) rightpoints(2,2) 1 0 0 0;
         0 0 0 rightpoints(2,1) rightpoints(2,2) 1;
         rightpoints(3,1) rightpoints(3,2) 1 0 0 0;
         0 0 0 rightpoints(3,1) rightpoints(3,2) 1];
     b = [leftpoints(1,1);leftpoints(1,2);leftpoints(2,1);leftpoints(2,2);leftpoints(3,1);leftpoints(3,2)];
     F = A \ b;
     F = [F(1:3)';F(4:6)'];
end

