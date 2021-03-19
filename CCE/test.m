Wk = [
        1,1,0,0,0,0,0;
        1,1,1,1,0,0,0;
        0,1,1,0,0,0,0;
        0,1,0,1,0,0,0;
        0,0,0,0,1,1,0;
        0,0,0,0,1,1,1;
        0,0,0,0,0,1,1;
      ];
iternum = 2;
arr = {};
arr = [arr, Wk(1:4,1:4)];
arr = [arr, Wk(5:7,5:7)];
offSet = [0,4];
arrTemp = arr;
[~,groups] = size(arr);
cc_set = [];
for k=1:iternum
    %分组筛选聚类中心
    cc = [];
    label = [];
    for j=1:groups
        cc_temp = [];
        arrTemp{j} = arrTemp{j}*arr{j};
        arrTemp{j} = arrTemp{j}/max(max(arrTemp{j}));
        [ND,ND] = size(arrTemp{j});
        for i=1:ND
            if(max(arrTemp{j}(i,i))==max(arrTemp{j}(i,:))&&arrTemp{j}(i:i)~=0)
                cc = [cc,i+offSet(j)];
                cc_temp = [cc_temp,i];
            end
        end
        cn = length(cc_temp);    %cluster centers number
        
        %处理label
        label_temp = zeros(1,ND);
        label_temp(cc_temp) = 1:cn;
        tmp = diag(arrTemp{j});
        tmp = tmp(cc_temp)';
        for i=1:ND
            [maxd,ind] = max(arrTemp{j}(i,cc_temp)./tmp);
            if (maxd==0)
                label_temp(i) = 0;
                continue;
            end
            label_temp(i) = label_temp(cc_temp(ind));
        end
        label = [label,label_temp+offSet(j)];
    end
    cc_set = [cc_set;{cc}];
    
    
end