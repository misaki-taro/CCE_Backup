function [dist_nm,dist]=distance2matrix(X)%distance square matrix
    % 将每一个pages当做是一个x
    % 这里的dist其实就是通过高光谱降维，然后用L2范式||xi-xj||^2映射成pages*pages的矩阵
    % 其实就是Spectral Clustering的无向权重图
    [ND, N]=size(X);
    tmp=sum(X.*X, 2);
    xx1=repmat(tmp,1,ND);
    xx2=repmat(tmp',ND,1);
    dist=(xx1+xx2-2*X*X'); 
    
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