function [dist_nm, dist] = distance2matrix_linear_kernel(X)
%   试一下用曼哈顿距离
    %ND 是 pages  N是维度
    [ND, N] = size(X);
    dist = zeros(ND);
    for i=1:ND-1
        for j=i+1:ND
            res1 = sum(abs(X(i,:)-X(j,:)));
            dist(i,j) = res1;
            dist(j,i) = res1;
        end
    end
    dist_flat=dist(:);
    if max(dist_flat)~=min(dist_flat)
        for i=1:size(dist_flat)
            dist_flat(i)= (dist_flat(i)-min(dist_flat))/(max(dist_flat)-min(dist_flat));
        end
    else
        dist_flat = dist_flat;
    end
    dist_nm= reshape(dist_flat,ND,ND);
    temp1 = dist_nm(:,1:ND-1);
    temp2 = dist_nm(:,2:ND);
    temp = temp1-temp2;
    maxList = [];
    for i = 1:ND
        maxList = [maxList,max(temp(i:i,:))];
    end
    minNum = min(maxList);
end