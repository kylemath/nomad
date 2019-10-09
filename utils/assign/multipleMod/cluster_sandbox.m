clear; 
close all;

rng(420);
rand_jitter = 2;

[X_tmp, Y_tmp] = meshgrid(4:1:7, 1:1:8);
X_tmp = X_tmp(:) + rand_jitter * rand(length(X_tmp(:)), 1);
Y_tmp = Y_tmp(:) + rand_jitter * rand(length(X_tmp(:)), 1);
X = [X_tmp, Y_tmp];

n_groups = 8;
max_iter = 10;
n_init = 10;

[labels, kmeans_labels] = equal_group_kmeans(X, n_groups, max_iter, n_init);

figure;
hold on;
dotsize = 100;
data = X;

subplot(121);
scatter(data(:,1), data(:,2), dotsize, labels, 'filled');
title('Best equal sized groups');
pbaspect([1 1 1])

subplot(122);
scatter(data(:,1), data(:,2), dotsize, kmeans_labels, 'filled');
title('Naive k-means');
pbaspect([1 1 1])