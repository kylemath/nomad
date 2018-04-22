function [mux_numbers mux_list lowest_left] = assign_mux

% Takes the source and detector locatoins from Montage Design and assigns
% mux numbers to each of the source locations in order to avoid cross talk

%Does not let any two of the same mux number near any single detector, by
%randomly assigning mux numbers starting with a random detector

%is called multiple times by montage design to start a new random attempt




global mtg


%makes a list from 1 to n_det and then randomizes them
det_swapper = 1:mtg(mtg(1).current).n_dets;
det_swapper = det_swapper(randperm(mtg(mtg(1).current).n_dets));


%Creates a list of the possible mux numbers to assign to all spaces
%The list is n_src by 1
mux_list = repmat(1:mtg(mtg(1).current).n_muxs,1,mtg(mtg(1).current).n_banks);
mux_list = mux_list(randperm(length(mux_list)));

%Initializes a ones matrix of the possible mux numbers left for each det
%n_det by n_mux

mtg(mtg(1).current).det_mux_list = ones(mtg(mtg(1).current).n_dets,mtg(mtg(1).current).n_muxs);   %ones are possible, zero are not


%Creates an array of zeros into which the mux_numbers for each src are put

mux_numbers = zeros(mtg(mtg(1).current).n_srcs,1);

%----------------------------------------------------------
%Loop until all det have no more srcs to fill

% while 1   
for current_det = det_swapper

    %shifts through the srcs for the current det, 
    %if they are less than mtg(mtg(1).current).max_dist, it gives them the next number on mux_list

    for i_src = 1:mtg(mtg(1).current).n_srcs                 
        if mtg(mtg(1).current).src_dist(current_det,i_src) <= mtg(mtg(1).current).max_dist        %if that src in in distance of the current   
            if mux_numbers(i_src) == 0                %If that spot isn't alraedy assigned a mux
                
                for i_mux_list = 1:length(mux_list)         %Find the next mux number in the list that is not already within range of a detector attached to the current source
                    good_mux = 1;                   
                    for i_det = 1:mtg(mtg(1).current).n_dets                      %For each detector                           
                        if mtg(mtg(1).current).close_dets(i_src,i_det)        %If this src is in range
                            if mtg(mtg(1).current).det_mux_list(i_det,mux_list(i_mux_list)) == 0      %if that det does not have this mux number in range
                                good_mux = 0;
                                break
                            end
                        end
                    end
                    if good_mux == 1                    %if none of the detectros in range have a src with that mux
                        mux_numbers(i_src) = mux_list(i_mux_list);        %Assign the current one and break out
                        break
                    end
                end
                                 
                for i_det = 1:mtg(mtg(1).current).n_dets
                    if mtg(mtg(1).current).src_dist(i_det,i_src) <= mtg(mtg(1).current).max_dist
                        mtg(mtg(1).current).det_mux_list(i_det,mux_list(i_mux_list)) = 0;
                    end
                end
                
                if mux_numbers(i_src) > 0
                    mux_list(i_mux_list) = [];    
                else
                end
            end
            
        end
    end

end
lowest_left = length(mux_list);











