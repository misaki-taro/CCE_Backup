clc; clear; close all; warning('off');

%% 加载高光谱数据
load('F:\Misaki\CCE_Backup\CCE\data\Indiana.mat');
% load('F:\CCE\data\PaviaU.mat');
% load('F:\CCE\data\Salinas.mat');

[rows, cols, pages] = size(cube_data);
cube_data_flat = reshape(cube_data, rows * cols, pages)';	% 三维变二维
label_data_flat = label_data(:);
cube_data_nm_flat = mapminmax(cube_data_flat, 0, 1) ;  % 数据归一化0~255
cube_data_nm = reshape(cube_data_nm_flat', rows, cols, pages);

%% CCE

[cc_set,label_set,cost_set]=CCE(cube_data_flat);
%Gaussian kernel 构建的
[~,dist1] = distance2matrix(cube_data_nm_flat);
[~,dist] = distance2matrix(cube_data_flat);
% showSMat(dist1);
% %linear kernel 构建的
% [~,dist] = distance2matrix_linear_kernel(cube_data_flat);
% dist = dist-diag(diag(dist));
ll = zeros(1,length(cc_set));
for i = 1:length(cc_set)
    ll(i) = length(cc_set{i});
end

figure;
scatter(1:length(cost_set), ll, 'b');
hold on;
plot(1:length(cost_set), ll, 'b');

% 可视化
bs_visualization_mds(dist,cc_set{find(ll==mode(ll),1)},label_set(find(ll==mode(ll),1),:));

%分类
band_idx_cce = cc_set{ll==mode(ll)};
band_size = length(band_idx_cce);
cube_data_select_cce = cube_data_flat(band_idx_cce(:),:)';
[pred_labels_cce, Accuracy_cce] = svm(cube_data_select_cce, label_data_flat);    % svm

%     %
% sigSq2=0.0010;
% lastPara = 0.0005;
% gap = 0.0001;
% rounded = 4;
% band_sizes = [];
% while(round(sigSq2,5) ~= round(lastPara,rounded))
%     %% CCE
%     
%     [cc_set,label_set,cost_set]=CCE(cube_data_flat,sigSq2);
%     [~,dist] = distance2matrix(cube_data_flat);
%     ll = zeros(1,length(cc_set));
%     for i = 1:length(cc_set)
%         ll(i) = length(cc_set{i});
%     end

%     figure;
%     scatter(1:length(cost_set), ll, 'b');
%     hold on;
%     plot(1:length(cost_set), ll, 'b');

    % 可视化
%     bs_visualization_mds(dist,cc_set{find(ll==mode(ll),1)},label_set(find(ll==mode(ll),1),:));

    %分类
%     band_idx_cce = cc_set{ll==mode(ll)};
%     band_size = length(band_idx_cce);
%     cube_data_select_cce = cube_data_flat(band_idx_cce(:),:)';
%     [pred_labels_cce, Accuracy_cce] = svm(cube_data_select_cce, label_data_flat);    % svm
%     band_sizes = [band_sizes; sigSq2, band_size];
%     sigSq2 = sigSq2 - gap
% end
% disp("select ok!");

%     %%
% averageArr = [];
% 
%     [cc_set,label_set,cost_set]=CCE(cube_data_flat);
%     [~,dist] = distance2matrix(cube_data_flat);
%     ll = zeros(1,length(cc_set));
%     for i = 1:length(cc_set)
%     ll(i) = length(cc_set{i});
%     end
% % 
% %     figure;
% %     scatter(1:length(cost_set), ll, 'b');
% %     hold on;
% %     plot(1:length(cost_set), ll, 'b');
% % 
% %     % 可视化
% %     bs_visualization_mds(dist,cc_set{find(ll==mode(ll),1)},label_set(find(ll==mode(ll),1),:));
% 
% %     %分类
% %     band_idx_cce = cc_set{ll==mode(ll)};
% %     band_size = length(band_idx_cce);
% %     cube_data_select_cce = cube_data_flat(band_idx_cce(:),:)';
% % for k=1:5
% %     [pred_labels_cce, Accuracy_cce] = svm(cube_data_select_cce, label_data_flat);    % svm
% %     averageArr = [averageArr;Accuracy_cce]
% % end
% 
