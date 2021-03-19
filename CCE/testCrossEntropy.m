A = [
    1.0,1.0,1.0;
    1.0,1.5,1.6;
    1.2,0.9,1.3;
    10.0,10.0,10.0;
    10.0,10.5,10.6;
    10.2,9.9,10.3
];  %   6samples and 3dimension
[dist_nm, dist] = distance2matrix(A);   %   dist_nm归一化 dist

[ND,~] = size(dist_nm);

% %确定初始dc
% percent = 2.0;
% position = round(ND*(ND-1)*percent/100);
% dist_flat = dist_nm(:);
% sda = sort(dist_flat);
% dc = sda(position);

dc = 0.01;
%normalize W
W = exp(-dist_nm/dc);
D = diag(sum(W,2));
D = D^(-0.5);
W = D*W*D

%use cross entropy
tmp1 = sum(W,2);
tmp2 = log(tmp1);
E = -(tmp1'*tmp2);