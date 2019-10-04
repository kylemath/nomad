function [group_labels] = cluster_equal_groups(data, n_groups, n_members)
% equal-size clustering based on data exchanges between pairs of clusters
% data is n by d where d is the dimensionality
% group_labels match these n rows of data

	dum = size(data);
	n_samples = dum(1);

	% no need to calculate n_members if it is given

	distances = squareform(pdist(data));
	memberships = kmeans(data, n_groups);
	display(memberships');
	current_err = average_data_distance_error(n_groups, memberships, distances);

	i_try = 1;
	while 1
		past_err = current_err;
		for a = 1:n_samples
			for b = 1:a
				% exchange membership and check new error
				[memberships(a), memberships(b)] = deal(memberships(b), memberships(a));
				test_err = average_data_distance_error(n_groups, memberships, distances);
				fprintf("{%d}: {%d}<->{%d} E={%d} \n", i_try, a, b, test_err)
				if test_err < current_err
					current_err = test_err;
				else
					% put them back
					[memberships(a), memberships(b)] = deal(memberships(b), memberships(a));
				end
			end
		end
		if past_err == current_err
			break
		end
		i_try = i_try + 1;
	end
	group_labels = memberships;
end






