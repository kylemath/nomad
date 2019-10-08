clear; 
close all;

[X_tmp, Y_tmp] = meshgrid(4:1:7, 1:1:8);
X_tmp = X_tmp(:) + .4*rand(length(X_tmp(:)), 1);
Y_tmp = Y_tmp(:) + .4*rand(length(X_tmp(:)), 1);
X = [X_tmp, Y_tmp];

% display(data);

n_groups = 8;
max_iter = 100;
  
% Precalculate n_samples
data_size = uint8(size(X));
n_samples = data_size(1);

% init cluster centers based on random sampling of points
sample_ids = randperm(n_samples, n_groups);
centers = X(sample_ids, :);

% init distance storgare
distances = zeros(n_samples);

% init class label array and minimum distance array
labels = -1 * ones(n_samples, 1);
mindist = inf * ones(n_samples, 1);

% init placehold retrun values
best_labels = [];
best_inertia = []; 
best_centers = [];

% iterate
for i_iter = 1:max_iter
  % store the old cluter centroids
  centers_old = centers;

  % calculate Euclidean distances between all point/center pairs
  % https://uk.mathworks.com/help/stats/pdist2.html
  all_distances = pdist2(centers, X, 'euclidean');

  for point_id = 1:n_samples
    % printf('poind_id %d \n', point_id);
    
    % sort the points by distance
    [sorted_distances, sorted_point_ids] = sort(all_distances(:, point_id));

    % initial assignment of labels
    % and calculation of minimum distance from points to centers
    
    % for each cluster in the sorted_point_ids
    for cluster_id = sorted_point_ids'
      
      % fallback point_distance is the distance to that cluster
      point_dist = sorted_distances(cluster_id);
      
      % if the group is not yet 'full', use explicit floor division
      if ~(length(find(labels == cluster_id)) >= idivide(n_samples, n_groups, 'floor'))

        % assign this point to the given group and update min distance
        [labels(point_id), mindist(point_id)] = deal(cluster_id, point_dist);
        break
      end
    end
  end

  % refine clustering
  transfer_list = [];
  best_mindist = mindist;
  best_labels = labels;

  % iter through points by distance (highest to lowest)
  [dum, isort] = sort(mindist);
  for point_id = isort(end:-1:1)'
    point_cluster = labels(point_id);

    %see if there is an opening on the best cluster for this point
    [sorted_vals, sort_idx] = sort(all_distances(:, point_id));
    cluster_id = sort_idx(1);
    point_dist = sorted_vals(1);

    if ~((length(find(labels == cluster_id)) >= ... 
        idivide(n_samples, n_groups, 'floor')) & ... 
        (point_cluster ~= cluster_id))
          % assign this point to the given group and update min distance
          [labels(point_id), mindist(point_id)] = deal(cluster_id, point_dist);
          [best_labels, best_mindist] = deal(labels, mindist);
      continue
    end

    % iter through candidates in the transfer list			
    for swap_candidate_id = transfer_list
      if point_cluster ~= labels(swap_candidate_id)
        % get the current distance of swap candidate
        cand_distance = mindist(swap_candidate_id);

        % get the potential distance of point
        point_distance = all_distances(labels(swap_candidate_id), point_id);

        %proceed if transfer will improve distance
        if point_distance < cand_distance
          labels(point_id) = labels(swap_candidate_id);
          mindists(point_id) = all_distances(labels(swap_candidate_id), point_id);
          labels(swap_candidate_id) = point_cluster;
          mindist(swap_candidate_id) = all_distances(point_cluster, swap_candidate_id);

          if sum(abs(mindist)) < sum(abs(best_mindist))
            %update the labels since the transfer was a success
            [best_labels, best_mindist] = deal(labels, mindist);
            break
          else
            %reset since the transfer was not a success
            [labels, mindist] = deal(best_labels, best_mindist);
          end
        end
      end
    end

    % Append point to end of transfer list
    transfer_list = [transfer_list, point_id];
  end

  % Calculate final inertia, and update labels using best_labels
  inertia = sum(best_mindist);
  labels = best_labels;

  % Recalculate centers
  for group_id = 1:n_groups
    centers(group_id, :) = mean(X(find(best_labels == group_id, 1), :), 1);
  end

  % UPDATE THE RETURN VALUES
  if best_inertia < 0 | inertia < best_inertia
    best_labels = labels;
    best_centers = centers;
    best_inertia = inertia;
  end
end

% test group sizes
best_group_sizes = zeros(n_groups, 1);
for group_id = 1:n_groups
  best_group_sizes(group_id) = length(find(best_labels == group_id));
end

display(best_group_sizes);