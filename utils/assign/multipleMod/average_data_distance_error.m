function [current_error] = average_data_distance_error(n_groups, memberships, distances)
% Calculate average distance between data in clusters.
	sum_error = 0;
	for i_group = 1:n_groups
		% indices of datapoints belonging to group i_group
		i = find(memberships == i_group);

		% cell array with N vectors to combine
		elements = {i, i};

		% set up the result
		combinations = cell(1, numel(elements));
		[combinations{:}] = ndgrid(elements{:});

		% there may be a better way to do this
		combinations = cellfun(@(x) x(:), combinations, 'uniformoutput', false);
		points = [combinations{:}];

		gd = zeros(length(points), 1);
		for jj = 1:size(points, 1)
			gd(jj, 1) = distances(points(jj, 1), points(jj, 2));
		end
		sum_error = sum_error + mean(gd);
	end
	current_error = sum_error / n_groups;
end