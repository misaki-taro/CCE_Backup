function [pred_labels, test_acc] = svm(data, labels)
    %% 读取数据
    data = data';
    [rows, pages] = size(data);
    class_names = [1:max(labels)]';
  
    %% 数据处理
    % 划分数据集
    train_num = 10;
    train_data = [];
    train_labels = [];
    test_data = [];
    test_labels = [];
    for i = 1:max(labels)
        temp =  find(labels==i);
        train_idx = sampling(temp, train_num);
        train_data = [train_data; data(:,train_idx)'];
        train_labels = [train_labels; labels(train_idx)];
        test_idx = temp(~ismember(temp,train_idx));
        test_data = [test_data; data(:,test_idx)'];
        test_labels = [test_labels; labels(test_idx)];
    end
    % 乱序
    sort_idx_1 = randperm(size(train_data, 1));
    temp_1 = train_data(sort_idx_1, :);
    train_data = temp_1;
    temp_2 = train_labels(sort_idx_1, :);
    train_labels = temp_2;
    
    sort_idx_2 = randperm(size(test_data, 1));
    temp_3 = test_data(sort_idx_2, :);
    test_data = temp_3;
    temp_4 = test_labels(sort_idx_2, :);
    test_labels = temp_4;
    
    %% 指定分类器
    template = templateSVM('KernelFunction', 'polynomial', 'PolynomialOrder', 2, 'KernelScale', 'auto', 'BoxConstraint', 1, 'Standardize', true);

    %% 训练
    classification_SVM = fitcecoc(train_data, train_labels, 'Learners', template, 'ClassNames', class_names);

    %% k折交叉验证
    partitioned_model = crossval(classification_SVM);
    val_acc = 1 - kfoldLoss(partitioned_model, 'LossFun', 'ClassifError');

    %% 预测
    pred_labels = predict(classification_SVM, test_data); 

    true_num = 0;
    for idx = 1:length(test_labels)
        if isequal(pred_labels(idx), test_labels(idx))
            true_num = true_num + 1;
        end
    end
    test_acc = true_num/length(test_labels);

    % 混淆矩阵
    confusion_mat = confusionmat(pred_labels, test_labels);
    figure();
    imagesc(confusion_mat);
    colorbar;
end