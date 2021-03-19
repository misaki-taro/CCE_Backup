function [theta,W] = getTheta(mat)
    [ND,N] = size(mat)
    temp1 = mat(:,1:ND-1);
    temp2 = mat(:,2:ND);
    temp = temp1-temp2;
    maxList = [];
    for i = 1:ND
        maxList = [maxList,max(temp(i:i,:))];
    end
    theta = min(maxList);
    mat_flat = mat(:);
    for i=1:size(mat_flat)
        if mat_flat(i)<theta
            mat_flat(i) = 0;
        end
    end
    W = reshape(mat_flat,ND,ND);
end    