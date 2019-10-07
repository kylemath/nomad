%function [best_labels, best_centers, best_intertia, best_group_sizes, i_iter] = equal_group_kmeans(X, n_groups, max_iter)
ccc
[X,Y] = meshgrid(4:1:7,1:1:8)
X = X(:) + .4*rand(length(X(:)),1);
Y = Y(:) + .4*rand(length(X(:)),1);
X = [X,Y]; 

n_groups = 8;
max_iter = 100;

n_samples = length(X);

% init cluster centers based on random sampling of points
centers = X(randperm(n_samples,n_groups),:);

% init distance storgare
distances = zeros(n_samples);

% init class label array and minimum distance array
labels = -1 * ones(n_samples, 1);
mindist = inf * ones(n_samples, 1); 

% init placehold retrun values
best_labels = [];
best_inertia = -1; 
best_centers = [];

% iterate
for i_iter = 1:max_iter
	
	% store the old cluter centroids
	centers_old = centers;

	% calculate euclidian distances between points/centers pairs
	all_distances = sum(centers * centers', 2) - 2 * (centers * X') + sum(X * X', 2)';

	for point_id = 1:n_samples

		%sort the points by distance
		[sorted_vals, sort_idx] = sort(all_distances(:,point_id));

		% initial assignmen tof labels and mindist	
		for cluster_id = sort_idx'
			point_dist = sorted_vals(cluster_id);
			if ~(length(find(labels==cluster_id)) >= n_samples/n_groups)
				labels(point_id) = cluster_id;
				midist(point_id) = point_dist;
				break
			end
		end
	end

	% refine clustering
	transfer_list = [];
	best_mindist = mindist;
	best_lables = labels;

	% iter through points by distance (highest to lowest)
	[dum, isort] = sort(mindist);
	for point_id = isort(end:-1:1)'
		point_id
		point_cluster = labels(point_id);

		%see if there is an opening on the best cluster for this point
		[sorted_vals, sort_idx] = sort(all_distances(:,point_id));
		cluster_id = sort_idx(1);
		point_dist = sorted_vals(1);

		if ~((length(find(labels==cluster_id)) >= n_samples/n_groups) & (point_cluster ~= cluster_id))
			labels(point_id) = cluster_id;
			mindist(point_id) = point_dist;
			best_labels = labels;
			best_mindist = mindist;
			continue
		end

		% iter through candidates in the transfer list			
		for swap_candidate_id = transfer_list
			if point_cluster ~= labels(swap_candidate_id)
				%get the current distance of swap candidate
				cand_distance = mindist(swap_candidate_id);

				%get the potential distance of point
				point_distance = all_distances(labels(swap_candidate_id), point_id);

				%proceed if transfer will improve distance
				if point_distance < cand_distance
					labels(point_id) = labels(swap_candidate_id);
					mindists(point_id) = all_distances(labels(swap_candidate_id), point_id);
					labels(swap_candidate_id) = point_cluster;
					mindist(swap_candidate_id) = all_distances(point_cluster, swap_candidate_id);

					if sum(abs(mindist)) < sum(abs(best_mindist))
						fprintf('transfer success')
						%update the labels since the transfer was a success
						best_labels = labels;
						best_mindist = mindist;
						break
					else
						fprintf('transfer unscucessful')
						%reset since the transfer was not a success
						labels
						best_labels
						labels = best_labels;
						mindist = best_mindist;
					end
				end
			end						
		end

		% add point to transfer list
		transfer_list = [transfer_list, point_id]
	end

	% calculate final inertia
	inertia = sum(best_mindist);
	labels = best_labels;

	% recalculate centers
	for group_id = 1:n_groups
		best_labels %SIZE [] 
		group_id
		centers(group_id,:) = mean(X(find(best_labels == group_id,1)),1);
	end

	% update return values
	if best_inertia < 0 | inertia < best_inertia
		best_labels = labels;
		best_centers = centers;
		best_inertia = inertia;
	end

end

% test group sizes and 
best_group_sizes = zeros(n_groups,1);
for group_id = 1:n_groups 
	best_group_sizes(group_id) = length(find(best_labels==group_id));
end
best_group_sizes

	
%end


