[X,Y] = meshgrid(4:1:7,1:1:8)

X = X(:) + .4*rand(length(X(:)),1);
Y = Y(:) + .4*rand(length(X(:)),1);

figure; scatter(X,Y)

Z = [X,Y]; 

%%
k = 8;
opts = statset('Display','final');
[idx,C] = kmeans(Z,k,'Distance','sqeuclidean',...
    'Replicates',5,'Options',opts);


%%
figure;
styles = {'b.','g.','r.','c.','m.','m+','b+','g+'};
for i_cluster = 1:k
    plot(Z(idx==i_cluster,1),Z(idx==i_cluster,2),styles{i_cluster},'MarkerSize',12)
    hold on
end
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
title 'Cluster Assignments and Centroids'
hold off



labels = equal_group_kmeans(Z, 8, 100);
figure;
gscatter(Z(:,1),Z(:,2),labels);

%%
%try with kory's equal groups

% labels = cluster_equal_groups(Z, 8, 4);
% figure;
% gscatter(Z(:,1),Z(:,2),labels);


% for i=1:8 
% 	members(i) = length(find(labels==i));
% end

% members

