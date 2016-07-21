function set_n_demag(iteration, permut, func)
    global n
    global dx
    global n_demag
    binaryMatrix = de2bi([0:63], 6, 'left-msb'); % Specify a binary matric to get the sign for each element based on the sum of ones
    for i = 1:size(n_demag,1) % Nested loops to know the index
        for j = 1:size(n_demag,2)
            for l = 1:size(n_demag,3)
                value = 0.0;
                idx = zeros(1,3);
                idx(1) = mod( (i-1 + n(1) -1),(2*n(1)-1) ) - n(1) + 1;
                idx(2) = mod( (j-1 + n(2) -1),(2*n(2)-1) ) - n(2) + 1;
                idx(3) = mod( (l-1 + n(3) -1),(2*n(3)-1) ) - n(3) + 1;
                for s = 1:size(binaryMatrix,1) % Iterate binary matrix
                    x = (idx(permut(1)) + binaryMatrix(s,permut(1)) - binaryMatrix(s,permut(1)+3)) *dx(permut(1));
                    y = (idx(permut(2)) + binaryMatrix(s,permut(2)) - binaryMatrix(s,permut(2)+3)) *dx(permut(2));
                    z = (idx(permut(3)) + binaryMatrix(s,permut(3)) - binaryMatrix(s,permut(3)+3)) *dx(permut(3));
                    value = value + ((-1)^sum(binaryMatrix(s,:))) * newells(func,x,y,z);
                end
                n_demag(i,j,l,iteration) = (-value) / ( 4*pi*prod(dx) );
            end % l loop
        end % j  loop
    end % i loop
    
end % Function