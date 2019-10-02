function FinalSwap

global helm mtg

empty_spots = find(mtg(mtg(1).current).mux_numbers == 0);  %for recording remaining srcs
num_spots = length(empty_spots);
spot_found = zeros(mtg(mtg(1).current).lowest_left,1);  %for recording mux numbers success




tic
for i_spot = 1:num_spots
    
    %Find the max in each row and the max overall
    row_max = [];
    for i_row = 1:helm.n_rows
        [row_max(i_row,1) row_max(i_row,2)] = max(helm.clr{i_row}(:,1)-helm.clr{i_row}(:,2));
    end
    [a ix] = max(row_max(:,1));
    iy = row_max(ix,2);
    
    if helm.clr{ix}(iy,1) == helm.clr{ix}(iy,2); %if the best left is a grey area
        title(['No acceptable positions left for the ' num2str(length(empty_spots)) ' sources left, Restart'],'fontsize',15);
        break;
    end
    
    
    if isempty(empty_spots)
        break;
    end
    
    left_count = 0;
    for i_left = mtg(mtg(1).current).leftover  %for the best spot left, go through each leftover mux and see if you can put it there
        left_count = left_count+1;
        if spot_found(left_count) ~= 1  %unless this mux has been assigned
            possible_loc = 1; %flag if this spot is good
            
            for i_det = 1:mtg(mtg(1).current).n_dets  %go through all nearby detectors to check for conflict with leftover mux
                dx=mtg(mtg(1).current).det_xyz(i_det,1)-helm.xyz{ix}(iy,1);
                dy=mtg(mtg(1).current).det_xyz(i_det,1)-helm.xyz{ix}(iy,2);
                dz=mtg(mtg(1).current).det_xyz(i_det,1)-helm.xyz{ix}(iy,3);
                dist=sqrt(dx^2+dy^2+dz^2);
                if dist <= mtg(mtg(1).current).max_dist  %if this det is close to the source in question
                    
                    if mtg(mtg(1).current).det_mux_list(i_det,i_left) == 0 %if that detector can't take leftover
                        possible_loc = 0;  %flag it as bad
                    end
                end
            end
            
            %if it has gone through all the detectors and none are
            %in conflict
            
            if possible_loc == 1;
                i_src = empty_spots(1);
                spot_found(left_count) = 1;
                mtg(mtg(1).current).mux_numbers(i_src) = i_left;  %assign new mux number
                
                
                %record important information to change src position
                mtg(mtg(1).current).src_sch_coords(i_src,:)=helm.sch_coords{ix}(:,iy);    % for labeling & drawing lines
                mtg(mtg(1).current).src_sch_rc(i_src,:) = [ix iy];
                mtg(mtg(1).current).src_xyz(i_src,:)=helm.xyz{ix}(iy,:);
                mtg(mtg(1).current).src_xy(i_src,:) =helm.xy{ix}(iy,:);
                mtg(mtg(1).current).src_labels(i_src,:)=[helm.labels(ix,:) sprintf('%02.0f',iy)];
                
                mtg(mtg(1).current).src_i(i_src) = helm.sensor_i{ix}(iy,:);      %det number in elp list
                mtg(mtg(1).current).src_helm_loc(mtg(mtg(1).current).src_i(i_src)) = i_src; %I think this is needed for deleting
                
                % scan detectors to determine close_dets
                mtg(mtg(1).current).close_dets(i_src,:) = 0; %reset the detectors near this srcs
                for i_det=1:length(mtg(mtg(1).current).det_sch_coords)    % scan dets
                    dx=mtg(mtg(1).current).src_xyz(i_src,1)-mtg(mtg(1).current).det_xyz(i_det,1);
                    dy=mtg(mtg(1).current).src_xyz(i_src,2)-mtg(mtg(1).current).det_xyz(i_det,2);
                    dz=mtg(mtg(1).current).src_xyz(i_src,3)-mtg(mtg(1).current).det_xyz(i_det,3);
                    mtg(mtg(1).current).src_dist(i_det,i_src)=sqrt(dx^2+dy^2+dz^2);
                    if mtg(mtg(1).current).src_dist(i_det,i_src) < mtg(mtg(1).current).max_dist  % if this det is close enough..
                        mtg(mtg(1).current).close_dets(i_src,i_det)=1;%stash it for adding selected mux # below
                    end
                end % i_det
                
                temp = helm.clr{ix}(iy,1);   % swith to make blue
                helm.clr{ix}(iy,1) = helm.clr{ix}(iy,3);
                helm.clr{ix}(iy,3) = temp;
                
                
                %if this detector now has the max number of possible
                %srcs based on the number of muxs
                for i_det = find(mtg(mtg(1).current).close_dets(i_src,:) == 1)
                    if length(find(mtg(mtg(1).current).close_dets(:,i_det)) == 1) == mtg(mtg(1).current).n_muxs
                        
                        for kx=1:helm.n_rows
                            for ky=1:length(helm.xyz{kx})
                                dx=mtg(mtg(1).current).det_xyz(i_det,1)-helm.xyz{kx}(ky,1);
                                dy=mtg(mtg(1).current).det_xyz(i_det,2)-helm.xyz{kx}(ky,2);
                                dz=mtg(mtg(1).current).det_xyz(i_det,3)-helm.xyz{kx}(ky,3);
                                dist(kx,ky)=sqrt(dx^2+dy^2+dz^2);
                                if helm.clr{kx}(ky,1) > helm.clr{kx}(ky,3) %if this isnt a src hole
                                    if helm.type(kx) == helm.type(ix) && dist(kx,ky) <= mtg(mtg(1).current).max_dist && dist(kx,ky) >= mtg(mtg(1).current).min_dist % increment shade depending on distance
                                        helm.clr{kx}(ky,:)= helm.src_clr;
                                        
                                    end
                                end
                            end % 'hole' loop
                        end % row loop
                    end
                end
                
                
                empty_spots(1) = [];  %record that this src now has a mux number
                break;
                
                
            end
        end
    end
    
end
toc

%recompute graph
mtg(mtg(1).current).V = 1:mtg(mtg(1).current).n_srcs;
mtg(mtg(1).current).E = [];
mtg(mtg(1).current).E_mat = zeros(length(mtg(mtg(1).current).V));
i_edge = 1;
for i_det = 1:mtg(mtg(1).current).n_dets
    clique = find(mtg(mtg(1).current).close_dets(:,i_det) == 1);
    for i_cli = 1:length(clique)-1
        for i_cli2 = i_cli+1:length(clique)
            mtg(mtg(1).current).E(i_edge,:) = [clique(i_cli) clique(i_cli2)];
            mtg(mtg(1).current).E_mat(clique(i_cli),clique(i_cli2)) = 1;
            mtg(mtg(1).current).E_mat(clique(i_cli2),clique(i_cli)) = 1;
            i_edge = i_edge+1;

        end
    end
end
