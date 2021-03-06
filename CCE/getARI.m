%得到ARI
%parameters:真实的标签，聚类标签
function[ARI,t] = getARI(r_label, c_label)
    %行代表真实的分类，列代表聚类分类
    n = length(r_label);
    row = 3;
    col = max(c_label);
    c_table = zeros(row+1, col+1);  %列联表
    r_label_temp = zeros(1,n);
    %构造列联表
    for i=1:n
        if(r_label{i} == "setosa")
            r_label_temp(i) = 1;
        elseif(r_label{i} == "versicolor")
            r_label_temp(i) = 2;
        else
            r_label_temp(i) = 3;
        end
        r = r_label_temp(i);
%         r = r_label(i);
        c = c_label(i);
        c_table(r,c) = c_table(r,c)+1;
    end
    for i=1:row
        for j=1:col
            c_table(i,col+1) = c_table(i,col+1)+c_table(i,j);
        end
    end
    for i=1:col
        for j=1:row
            c_table(row+1,i) = c_table(row+1,i)+c_table(j,i);
        end
    end
    t = c_table;
    sum1 = 0;
    sum2 = 0;
    sum3 = 0;
    sum4 = 0;
    for i=1:row
        for j=1:col
            if c_table(i,j)<2
                continue;
            end
            sum1 = sum1 + nchoosek(c_table(i,j),2);
        end
    end
    for i=1:row
        if c_table(i,col+1)<2
            continue;
        end
        sum2 = sum2 + nchoosek(c_table(i,col+1),2);
    end
    for j=1:col
        if c_table(row+1,j)<2
            continue;
        end
        sum3 = sum3 + nchoosek(c_table(row+1,j),2);
    end
    sum4 = nchoosek(n,2);
    ARI = (sum1-(sum2*sum3)/sum4)/(0.5*(sum2+sum3)-sum2*sum3/sum4);
end