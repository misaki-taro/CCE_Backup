function [dist_nm, dist] = distance2matrix_poly_kernel(X)
    [ND, N] = size(X);
    c = 1;
    d = 3;
    dist=(X*X'+c).^10;
    dist_flat = dist(:);
    if max(dist_flat)~=min(dist_flat)
        for i=1:size(dist_flat)
            dist_flat(i)= (dist_flat(i)-min(dist_flat))/(max(dist_flat)-min(dist_flat));
        end
    else
        dist_flat = dist_flat;
    end
    dist_nm= reshape(dist_flat,ND,ND);
end