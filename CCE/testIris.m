load fisheriris;
[~,dist] = distance2matrix(meas);   %得到欧氏距离(平方)的相似矩阵
[ND,P] = size(meas);    %ND:数据的样本数  P:数据维度

%%欧式距离距离矩阵
dist3 = zeros(ND,ND);
for i=1:ND
    for j=1:ND
        dist3(i,j) = pdist2(meas(i,:),meas(j,:));
    end
end

%%CCE
label = 0;
sigma = 0.15;
iternum = 300;   %迭代次数
cn1num = 10;    %当聚类中心只有一个的时候最多再迭代10次
normalize = 1;  %0的时候不标准化，1的时候标准化
cn_set = [];
cc_set = [];
label_set = [];
[ND,P] = size(meas);    %ND:数据的样本数  P:数据维度
[dist2,~] = distance2matrix(meas);  %归一化的欧氏距离相似矩阵
dc = sigma*sigma;

W = exp(-dist2/dc); %高斯核
if (normalize==1) %Normalize
    D=diag(sum(W,2));
    D=D^(-0.5);
    W=D*W*D;%Normalize

end
W0 = W;
Wk = 1;


for k=1:iternum
    Wk = Wk*W0;
    Wk = Wk/max(max(Wk));
    cc = [];    %每一次迭代的聚类中心
    for i=1:ND
        if ( Wk(i,i)==max(Wk(i,:)) && Wk(i,i)~=0)
            cc=[cc,i];
        end
    end
    cn = length(cc);    %聚类中心的数量
    cn_set = [cn_set, cn];
    if cn>40
        continue;
    end
    
    if cn==0
        return;
    end
    
    costfun = 0;
    
    %%将所有点分配到对应的聚类中心
    label = zeros(1,ND);
    label(cc) = 1:cn;
    tmp = diag(Wk);
    tmp = tmp(cc)';
    
    for i=1:ND
        [maxd,ind]=max(Wk(i,cc)./tmp);
        if (maxd==0)
            label(i)=0;
            continue;
        end
        label(i)=label(cc(ind));
    end
    cc_set=[cc_set;{cc}];
    label_set=[label_set;label];
    
    if cn==1
        cn1num=cn1num-1;
        if cn1num==0
            break;
        end
    end
end
disp('ok');

figure;
Y = zeros(1,length(cc_set));
for i=1:length(cc_set)
    Y(i) = length(cc_set{i});
end
scatter(1:length(cc_set), Y, 'b');
hold on;
plot(1:length(cc_set), Y, 'b');
xlabel('Iteration number');
ylabel('Number of clusters');

%%可视化
% 自带标签的分类
bs_visualization_iris(dist3, species);

% k-means可视化
result = kmeans(meas,3);
bs_visualization_cmds(dist3,cc_set{find(Y==3,1)},result);
% %分成两类的情况
% bs_visualization_cmds(dist3,cc_set{find(Y==mode(Y),1)},label_set(find(Y==mode(Y),1),:));    %mode是众数的意思

%分成三类的情况
bs_visualization_cmds(dist3,cc_set{find(Y==3,1)},label_set(find(Y==3,1),:));    %mode是众数的意思