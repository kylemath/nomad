

function [coloring leftover] = dsatur2_rand

global mtg


V = mtg(mtg(1).current).V;
E = mtg(mtg(1).current).E;
n = length(V);
coloring = zeros(n,1);
max_per_color = mtg(mtg(1).current).n_banks;
mux_list = repmat(1:mtg(mtg(1).current).n_muxs,1,mtg(mtg(1).current).n_banks);
mux_list = mux_list(randperm(length(mux_list)));


% Start with the node that has the maximum degree.
% Color the current node with the lowest available color.
% Select the next node by selecting the node with the maximum degree of saturation.
% This means that you have to select the node that has the most number of unique neighboring colors.
% In case of a tie, use the node with the largest degree.
% Goto step 2. until all nodes are colored.

% Degrees

for i=1:n
    v = i;
    Degrees(i,1) = size([E(find(E(:,1)==v),2); E(find(E(:,2)==v),1)],1);
end

% Degrees of saturation
Degrees_of_saturation = zeros(n,1);

% Coloring
for i=1:n
    if i == 1
        [value index] = max(Degrees);
        v = index(1);
        coloring(v) = mux_list(1);
        assigned_color_v = mux_list(1);
        mux_list(1) = [];

    else
        Uncolored = find(coloring==0);
        index_temp = find(Degrees_of_saturation(Uncolored)==max(Degrees_of_saturation(Uncolored)));
        index = Uncolored(index_temp);
        if(size(index,1)>1)
            [value1 index1] = max(Degrees(index));
            v = index(index1);
        else
            v = index;
        end

        % Assign first available color to v
        neighbors = [E(find(E(:,1)==v),2); E(find(E(:,2)==v),1)];
        for j=mux_list
            if size(find(coloring(neighbors)==j),1)==0   
                if size(find(coloring(:)==j)) < max_per_color    %Added by KEM to keep less than n_banks
                    coloring(v) = j;
                    assigned_color_v = j;
                    mux_list(find(mux_list == j,1)) = [];
                    break;
                end
            end
        end

    end

    % Update Degrees of saturation
    neighbors_v = [E(find(E(:,1)==v),2); E(find(E(:,2)==v),1)];
    for j=1:size(neighbors_v,1)
       u = neighbors_v(j);
       neighbors_u = [E(find(E(:,1)==u),2); E(find(E(:,2)==u),1)];
       if size(find(coloring(neighbors_u)==assigned_color_v),1) == 1
           Degrees_of_saturation(u,1) = Degrees_of_saturation(u,1) + 1;
       end
    end

end

leftover = size(find(coloring == 0));




% from :
% http://arman.boyaci.ca/a-matlab-implementation-of-greedy-dsatur-coloring-algorithm/

% 
% Given a graph, vertex coloring is the assignment of colors to the vertices such that no two adjacents vertices share the same color. Vertex coloring problem is NP-hard for general graphs. However for some specific graph classes there are some positif results. For example by definition we can trivially color a bipartite graph using two colors.
% 
% 
% 
% There are polynomial time exact coloring algorithms for some subclass of graphs:
% 
% Interval graphs
% Chordal graphs (triangulated graphs)
% Permutation graphs
% All the graph classes above are part of a general graph class called Perfect Graphs. In all perfect graphs, the graph coloring problem can be solved in polynomial time.
% 
% On the other hand, there are various coloring heuristic algorithms in the literature. One of the simplest one is the following:
% 
% Make a non-increasing order of the vertices according to their degrees
% Consider one by one the vertices with this order and color them with the first available color (which does cause an infeasibility, if there no such a color exist create a new color)
% Another popular coloring algorithm is Brelaz?s DSATUR algorithm. There are two versions (exact and heuristic) of the algorithm. Here we will consider the heuristic (greedy) version of the algorithm.
% 
% Suppose we are given a graph and a partial coloring of this graph (some of the vertices are already colored). We define  saturation degree of a vertex as the number of different colors in the neighborhood of that vertex. In DSATUR algorithm, vertices are selected one by one with the following rule and are given the first available color.
% 
% Dynamic Order: Select a vertex v with the highest saturation degree, in case of tie select the one with highest (ordinary) degree. Update saturation degree values of the neighbors of v.
% 
% Matlab Code: DSATUR
