function assign_the_mux


global mtg

%Run the chosen coloring method



if strcmp(mtg(mtg(1).current).mux_assign_type,'Monte Carlo') == 1 && mtg(1).Parallel_toggle ~= 1
    
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = assign_mux;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end
 
    
elseif strcmp(mtg(mtg(1).current).mux_assign_type,'Monte Carlo') == 1 && mtg(1).Parallel_toggle == 1
    
    n_try = mtg(mtg(1).current).n_trys;
    lowest_left = zeros(1,n_try,'uint8');
    mux_numbers = zeros(mtg(mtg(1).current).n_srcs,n_try,'uint8');
    passed_mtg = mtg(mtg(1).current);
    tic
    parfor i_try = 1:n_try
        [mux_numbers(:,i_try) lowest_left(i_try) ] = assign_mux_parallel(passed_mtg);
    end
    toc
   
    
    [z i] = min(lowest_left);
    mtg(mtg(1).current).mux_numbers = mux_numbers(:,i);
    mtg(mtg(1).current).lowest_left = z;
    mtg(mtg(1).current).i_try = i;
    mtg(mtg(1).current).leftover = find(mtg(mtg(1).current).mux_numbers == 0);
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end
    
    
elseif strcmp(mtg(mtg(1).current).mux_assign_type,'Monte Carlo Src') == 1
        
        
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = assign_mux_src;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end

elseif strcmp(mtg(mtg(1).current).mux_assign_type,'Monte Carlo Matrix Det') == 1
        
        
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = mc_det;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end
    
elseif strcmp(mtg(mtg(1).current).mux_assign_type,'Monte Carlo Matrix DetMux') == 1
        
        
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = mc_detmux;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end
    
elseif strcmp(mtg(mtg(1).current).mux_assign_type,'Greedy') == 1
        
        
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = greedy_rand;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end
    
elseif strcmp(mtg(mtg(1).current).mux_assign_type,'DSATUR') == 1
        
        
    n_try = mtg(mtg(1).current).n_trys;
    mtg(mtg(1).current).lowest_left = mtg(mtg(1).current).n_srcs;
    lowest_left = zeros(1,n_try);
    tic
    for i_try = 1:n_try
        [mux_numbers leftover] = dsatur2_rand;
        lowest_left(i_try) = length(leftover);
        if lowest_left(i_try) < mtg(mtg(1).current).lowest_left
            mtg(mtg(1).current).lowest_left = lowest_left(i_try);
            mtg(mtg(1).current).mux_numbers = mux_numbers;
            mtg(mtg(1).current).leftover = leftover;
        end
        if mtg(mtg(1).current).lowest_left == 0
            break
        end
    end
    toc
    mtg(mtg(1).current).i_try = i_try;
    for i_det=1:mtg(mtg(1).current).n_dets
        mtg(mtg(1).current).solution_test{i_det} = mtg(mtg(1).current).mux_numbers(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    end    
    
end


