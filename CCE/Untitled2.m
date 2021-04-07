load fisheriris.mat;
[cc_set,label_set,cost_set] = CCE(meas);
ll = zeros(1,length(cc_set));
for i = 1:length(cc_set)
    ll(i) = length(cc_set{i});
end
[~,dist] = distance2matrix(meas);

figure;
scatter(1:length(cost_set), ll, 'b');
hold on;
plot(1:length(cost_set), ll, 'b');

% 可视化
bs_visualization_mds(dist,cc_set{find(ll==mode(ll),1)},label_set(find(ll==mode(ll),1),:));