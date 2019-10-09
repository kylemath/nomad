X = mtg.src_xyz; 

n_groups = 8;
max_iter = 10;
n_init = 20;

labels = equal_group_kmeans(X, n_groups, max_iter, n_init )

mtg.orig_mux_numbers = mtg.mux_numbers;
mtg.mux_numbers = labels;
mtg.n_muxs = 8;
mtg.n_banks = 4;

helm_draw_mtg



