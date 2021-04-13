function[ARI] = getARI(r_label, c_label)
    %行代表真实的分类，列代表聚类分类
    n = length(r_label);
    row = 3;
    col = max(c_label);
    c_table = zeros(row, col);
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
        c = c_label(i);
        c_table(r,c) = c_table(r,c)+1;
    end
end