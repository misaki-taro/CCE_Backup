%CCE:Clustering by connection center evolution,
%2018, Hairong Tang,Xiurui Geng
%output:---
%cc_set:the set of cluster centers for each iteration
%label_set:cluster the set of label for each iteration
%cost_set:the sets of the number of clusters and of the cost function for each iteration
%input:---
%X:origin data,[sample,dimension]
%sigSq2:the square of variance used in Gaussion kernel,
%normalize:normalize similarity matrix if it is 1
%iternum:the number of iteration of CCE

function [cc_set,label_set,cost_set]=CCE_modify(X,groups_num, groups_arr)

label=0;
% if  nargin<1
%     clear;
%     close all;
%
%     %read data
%     [filename, pathname] = uigetfile('*.txt', 'Pick a data file','C:\');
%     if isequal(filename,0)
%        disp('User selected Cancel');
%        return;
%     else
%        X=load(fullfile(pathname, filename));
%     end
%     normalize=0;
%     iternum=100;
%       plot(X(:,1),X(:,2),'r.');
%       sig=input('sigma=','s');
%         if isempty(sig)
%             sig=10;
%             sigSq2=sig^2;
%         else
%             sig=str2double(sig);
%             sigSq2=sig^2;
%         end
%         if sigSq2==0
%             return;
%         end
%
% end

if  nargin==3
    sigSq2=0.03;
    normalize=0;
    iternum=50;
end

if nargin==2
    normalize=0;
    iternum=50;
end

%calculate distance square matrix******************************
% 得到相似矩阵
[ND,P]=size(X);%ND samples,P dimensions
%欧氏距离
[dist2,dist3]= distance2matrix(X);

% %曼哈顿距离
% [dist2, ~] = distance2matrix_linear_kernel(X);
% lkjl=mapminmax(dist2(:));
% aa = dist2(:);
% dist2 = reshape(dist2(:),ND,P);

show1=0;
cn1num=10;%the largest number when cn==1

%gauss sigma, adjacent matrix
dc=sigSq2;

if ND<=5000
    %高斯核函数？  高斯距离   
    W=exp(-dist2/dc);
%     showSMat(dist3);
%     showSMat(dist2);
%     showSMat(W);
    
%     %linear kernel
%     [W,~] = distance2matrix_linear_kernel(X);
    
%     %Poly kernel
%     [W,~] = distance2matrix_poly_kernel(X);
    
    if (normalize==1) %Normalize
        D=diag(sum(W,2));
        D=D^(-0.5);
        W=D*W*D;%Normalize

    end
%     improvement of spectral clustering
%     [~,W] = getTheta(W);
    
    %         if cutdoor~=0
    %         end
end

% %试一下用linear kernel
% [W, ~] = distance2matrix_linear_kernel(X);


dist2=0;



W0=W;%%%%%%%


Wk=1;

cn_set=[];
cc_set=[];
label_set=[];
cost_set=[];
RI_set=[];
ARI_set=[];

%将矩阵按parameters来分组
arr = {};
for count=1:groups_num
    if (count == 1)
        arr = [arr, W(1:groups_arr(count),1:groups_arr(count))];
        continue;
    end
    start_ind = groups_arr(count-1)+1;
    end_ind = groups_arr(count);
    arr = [arr, W(start_ind:end_ind, start_ind:end_ind)];
end
arrTemp = arr;
%各个部分分组的offset
g_offset = [0];
for i=1:groups_num-1
    g_offset = [g_offset, groups_arr(i)];
end
for k=1:iternum %interation begin
    %分组筛选聚类中心
    cc = [];%cluster center
    label = [];
    for j=1:groups_num
        cc_temp = [];
        arrTemp{j} = arrTemp{j}*arr{j};  
        arrTemp{j} = arrTemp{j}/max(max(arrTemp{j}));
        [NDI, NDI] = size(arrTemp{j});
        for i=1:NDI
            if(max(arrTemp{j}(i,i))==max(arrTemp{j}(i,:))&&arrTemp{j}(i:i)~=0)
                cc = [cc,i+g_offset(j)];
                cc_temp = [cc_temp,i];  %不加offset的聚类中心（只单独看矩阵，local）
            end
        end
        cn = length(cc_temp);    %cluster centers number（local）
        
        %处理label
        label_temp = zeros(1,NDI);
        label_temp(cc_temp) = 1:cn;
        tmp = diag(arrTemp{j});
        tmp = tmp(cc_temp)';
        for i=1:NDI
            [maxd,ind] = max(arrTemp{j}(i,cc_temp)./tmp);
            if (maxd==0)
                label_temp(i) = 0;
                continue;
            end
            label_temp(i) = label_temp(cc_temp(ind));
        end
        [~,all_cc] = size(cc);
        [~,local_cc] = size(cc_temp);
        label = [label,label_temp+all_cc-local_cc]; %当前所有聚类中心减局部聚类中心就是类个数的偏移
    end
    cn = length(cc);
    
    if cn>40 %too large to cluster
        continue;
    end
    if cn==0
        return;
    end
    
    costfun=0;
%     %cluster all points
%     label=zeros(1,ND);
%     label(cc)=1:cn;
%     tmp=diag(Wk);
%     tmp=tmp(cc)';   %聚类中心的距离
%     
%     for i=1:ND
%         [maxd,ind]=max(Wk(i,cc)./tmp);
%         if (maxd==0)
%             label(i)=0;
%             continue;
%         end
%         label(i)=label(cc(ind));
%     end
    
    costJ_SC=cal_SC_cost(W0,label,cn);
    cost_set=[cost_set;[cn,costJ_SC]];
    cc_set=[cc_set;{cc}];
    label_set=[label_set;label];
    
    if cn==1
        cn1num=cn1num-1;
        if cn1num==0
            break;
        end
    end

end%k,iteration times
disp('ok!');
end

function costJ=cal_SC_cost(W,label,K) %Ncut
    [ND,ND]=size(W);
    costJ=0;
    for i=1:K
        tmpi = (label==i);
        tmpNi= (label~=i);
        costJ=costJ+sum(sum(W(tmpi,tmpNi)))/sum(sum(W(tmpi,:)));
    end
end
