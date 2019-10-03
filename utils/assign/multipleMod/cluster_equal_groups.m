function [group_labels] = cluster_equal_groups(data_points, group_size, n_cluster)
% equal-size clustering based on data exchanges between pairs of clusters 
% data_points is n by d where d is the dimensionality
% group_labels match these n rows of data_points

	dum = size(data_points);
	n_positions = dum(1);
	n_dim = dum(2);

	n_cluster = n_positions/group_size;

	function [current_error] = error(n_cluster, current_perm, distances)
	% return average distances between data in one cluster
	% averaged over all clusters
		sum_error = 0; 
		for i_cluster = 1:n_cluster
			%indeces of datapoints belonging to group i_member
			i = find(current_perm == i_cluster);
			sum_error = sum_error + mean(mean(distances(meshgrid(i, i))));
		end
		current_error = sum_error / n_cluster;
	end

	distances = squareform(pdist(data_points));
	current_perm = mod(randperm(n_positions),n_cluster)+1;
	current_error = error(n_cluster, current_perm, distances);

	i_try = 1;
	while 1
		error_pre = current_error;
		for j = 1:n_positions
			for k = 1:j
				%exchange membership and check new error
				[current_perm(j), current_perm(k)] = deal(current_perm(k), current_perm(j));
				error_post = error(n_cluster, current_perm, distances);

				if error_post < current_error
					current_error = error_post;
					current_perm(j)
					current_perm(k)
				else
					%put them back
					[current_perm(j), current_perm(k)] = deal(current_perm(k), current_perm(j));			
				end
			end
		end
		if error_pre == current_error
			break
		end
		i_try = i_try + 1;
	end
	group_labels = current_perm;
end






