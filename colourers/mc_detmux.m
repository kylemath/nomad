function [mux_numbers mux_list] = monte_carlo_detmux

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


%Creates an array of zeros into which the mux_numbers for each src are put

mux_numbers = zeros(mtg(mtg(1).current).n_srcs,1);

%----------------------------------------------------------
%Loop until all det have no more srcs to fill

% while 1   
for current_det = det_swapper
    
    %shifts through the srcs for the current det,
    %if they are less than mtg(mtg(1).current).max_dist, it gives them the next number on mux_list
    for i_src = 1:mtg(mtg(1).current).n_srcs
        if mtg(mtg(1).current).src_dist(current_det,i_src) <= mtg(mtg(1).current).max_dist  && mux_numbers(i_src) == 0      %if that src in in distance of the current           
            for i_mux_list = 1:length(mux_list)         %Find the next mux number in the list that is not already within range of a detector attached to the current source
                if isempty(find(mux_numbers(mtg(mtg(1).current).E_mat(i_src,:) == 1) == mux_list(i_mux_list),1)) && mux_numbers(i_src) == 0
                    mux_numbers(i_src) = mux_list(i_mux_list);        %Assign the current one and break out
                    mux_list(i_mux_list) = [];
                    break
                end
            end
        end      
    end   
end




