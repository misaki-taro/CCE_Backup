function [] = bs_visualization_iris(D, label)

    X = cmdscale(D, 2);

    %% 可视化
    figure;
    cmap=colormap(lines);
    iris_species = ["setosa","versicolor","virginica"];
    for i = 1:length(iris_species)
        idx = find(label==iris_species(i));
        size_all = ones(1, length(idx))*180;
        
        scatter(X(idx,1), X(idx,2), size_all,'.','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor',cmap(i,:));
        hold on;
    end

%     size_all = ones(1, length(D))*180;
%     scatter(X(:,1), X(:,2), size_all, 'b.');
%     hold on;
    
%     size_cent = ones(1, length(band_idx))*200;
%     %scatter(X(band_idx,1), X(band_idx,2), size_cent,'MarkerFaceColor',cmap(label(1,band_idx),:),'MarkerEdgeColor','k');

%     for k = 1:length(band_idx)
%         scatter(X(band_idx(k),1), X(band_idx(k),2), 130, 'o', 'MarkerFaceColor',cmap(label(1,band_idx(k)),:),'MarkerEdgeColor','k');
%         hold on;
% %         text(X(band_idx(k),1), X(band_idx(k),2), {band_idx(k)});
%     end
    
%     for k = 1:length(band_idx)
%         text(X(band_idx(k),1), X(band_idx(k),2), {band_idx(k), order(k)});
%     end

    title('Fisheriris Visualization (MDS)');
end