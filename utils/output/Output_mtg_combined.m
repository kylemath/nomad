function Output_mtg_combined

global mtg


n_det = mtg(1).n_dets;
oxy2_dets = find(mtg(1).det_name(1:mtg(1).n_dets) < 'a');  %find all the oxy2
oxy3_dets = find(mtg(1).det_name(1:mtg(1).n_dets) >= 'a'); %the others are opt3
n_det2 = length(oxy2_dets); 
n_det3 = length(oxy3_dets);  %every third detector is from oxy 2 in the CNL upstairs



n_src = mtg(1).n_srcs;
n_mux = mtg(1).n_muxs;
n_mtg = mtg(1).n_mtgs;
n_wvl = mtg(1).n_wvls;
wavelength = mtg(1).wvl(n_wvl:-1:1);
modulation_f = mtg(1).mdf;

n_chan2 = n_det2*n_mux;
n_chan3 = n_det3*n_mux;

out_src2 = [];
out_det2 = [];
out_mtg = [];
out_mtg2 = [];
out_mtg2b = [];
out_mtg3 = [];
out_mtg3b = [];
all_count = 0;

for i_mtg = 1:n_mtg

    
    [a i_sort] = sort(mtg(i_mtg).det_name(1:n_det));

    

    opt2_count = 0;
    opt3_count = 0;

    for i_det = i_sort %for each detector we find the shortest for each mux number
        if mtg(i_mtg).det_name(i_det) < 'a'  %upper case from opt2
            opt2_count = opt2_count + 1;

            for i_mux = 1:n_mux %Loop through all the mux numbers and do this
               current_min = 500; %just to start
               for i_src = 1:n_src %Loop through all the srcs
                    if mtg(i_mtg).mux_numbers(i_src,1) == i_mux        %finds all instances of the current mux channel
                        if mtg(i_mtg).src_dist(i_det,i_src) < current_min %Finds the shortest distance of those
                            current_min = mtg(i_mtg).src_dist(i_det,i_src);    %Updates the shortest distance
                            current_min_src = i_src;                    %And saves the src number that has that distance 
                        end
                    end
               end
               out_src2{opt2_count,i_mux} = mtg(i_mtg).src_labels(current_min_src,:); %This spits out the label of the hole that each mux number is in for each det
               if n_wvl == 2
                    out_wvl2{opt2_count,i_mux} = mod(mtg(i_mtg).mux_numbers_wvl(current_min_src),2)+1;
               elseif n_wvl == 1
                   out_wvl2{opt2_count,i_mux} = 1;
               end
            end
            out_det2{opt2_count,1} = mtg(i_mtg).det_labels(i_det,1:4);
            
        else
            opt3_count = opt3_count + 1;

            for i_mux = 1:n_mux %Loop through all the mux numbers and do this
               current_min = 500; %just to start
               for i_src = 1:n_src %Loop through all the srcs
                    if mtg(i_mtg).mux_numbers(i_src,1) == i_mux        %finds all instances of the current mux channel
                        if mtg(i_mtg).src_dist(i_det,i_src) < current_min %Finds the shortest distance of those
                            current_min = mtg(i_mtg).src_dist(i_det,i_src);    %Updates the shortest distance
                            current_min_src = i_src;                    %And saves the src number that has that distance 
                        end
                    end
               end
               out_src3{opt3_count,i_mux} = mtg(i_mtg).src_labels(current_min_src,:); %This spits out the label of the hole that each mux number is in for each det
               if n_wvl == 2
                    out_wvl3{opt3_count,i_mux} = mod(mtg(i_mtg).mux_numbers_wvl(current_min_src),2)+1;
               elseif n_wvl == 1
                   out_wvl3{opt3_count,i_mux} = 1;
               end
               
               end
            out_det3{opt3_count,1} = mtg(i_mtg).det_labels(i_det,1:4);
        end
    end




    %now create the cells to make the mtg file
    
    
    if i_mtg == 1

        out_mtg{1,1} = 'NEW';
        if n_det3 == 0
            if n_mtg == 2
                out_mtg{2,1} = [num2str(n_det2*n_mux*n_wvl) ' ' num2str(n_det2*n_mux*n_wvl)];
            elseif n_mtg == 1
                out_mtg{2,1} = [num2str(n_det2*n_mux*n_wvl)];
            end
        else
            if n_mtg == 2
                out_mtg{2,1} = [num2str(n_det2*n_mux*n_wvl) ' ' num2str(n_det3*n_mux*n_wvl) ' ' num2str(n_det2*n_mux*n_wvl) ' ' num2str(n_det3*n_mux*n_wvl)];
            elseif n_mtg == 1
                out_mtg{2,1} = [num2str(n_det2*n_mux*n_wvl) ' ' num2str(n_det3*n_mux*n_wvl)];
            end
        end
           
        out_mtg{2,2} = [];
        out_mtg{2,3} = [];
        out_mtg{2,4} = [];
        out_mtg{2,5} = [];
        
        opt2_count = 0;
        opt3_count = 0;

        for i_det = 1:n_det
            if mtg(i_mtg).det_name(i_det) < 'a' %Find uppercase
                opt2_count = opt2_count + 1;
                for i_mux = 1:n_mux
                    for i_wvl = 1:n_wvl
                        all_count = all_count + 1;
                        out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),1} = num2str(((opt2_count-1)*n_mux)+i_mux);
                        out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),2} = out_src2{opt2_count,i_mux};
                        out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),3} = out_det2{opt2_count,1};
                        if i_wvl == 1
                            out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   out_wvl2{opt2_count,i_mux} ));
                        elseif i_wvl == 2
                            out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   mod(out_wvl2{opt2_count,i_mux},2)+1 ));
                        end
                        out_mtg2{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),5} = num2str(modulation_f);
                    end
                end
            else
                opt3_count = opt3_count+1;
                for i_mux = 1:n_mux
                    for i_wvl = 1:n_wvl
                        all_count = all_count + 1;
                        out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),1} = num2str(((opt3_count-1)*n_mux)+i_mux);
                        out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),2} = out_src3{opt3_count,i_mux};
                        out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),3} = out_det3{opt3_count,1};
                        if i_wvl == 1
                            out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   out_wvl3{opt3_count,i_mux} ));
                        elseif i_wvl == 2
                            out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   mod(out_wvl3{opt3_count,i_mux},2)+1 ));
                        end
                        out_mtg3{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),5} = num2str(modulation_f);
                    end
                end
            end
        end
        
        out_mtg = [out_mtg; out_mtg2; out_mtg3];
        
    elseif i_mtg > 1
  

        opt2_count = 0;
        opt3_count = 0;

        for i_det = 1:n_det
            if mtg(i_mtg).det_name(i_det) < 'a'
                opt2_count = opt2_count + 1;
                for i_mux = 1:n_mux
                    for i_wvl = 1:n_wvl
                        all_count = all_count + 1;
                        out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),1} = num2str(((opt2_count-1)*n_mux)+i_mux+n_chan2);
                        out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),2} = out_src2{opt2_count,i_mux};
                        out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),3} = out_det2{opt2_count,1};
                        if i_wvl == 1
                            out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   out_wvl2{opt2_count,i_mux} ));
                        elseif i_wvl == 2
                            out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   mod(out_wvl2{opt2_count,i_mux},2)+1 ));
                        end
                        out_mtg2b{((opt2_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),5} = num2str(modulation_f);
                    end
                end
            else
                opt3_count = opt3_count+1;
                for i_mux = 1:n_mux
                    for i_wvl = 1:n_wvl
                    all_count = all_count + 1;
                    out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),1} = num2str(((opt3_count-1)*n_mux)+i_mux+n_chan3);
                    out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),2} = out_src3{opt3_count,i_mux};
                    out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),3} = out_det3{opt3_count,1};
                    if i_wvl == 1
                        out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   out_wvl3{opt3_count,i_mux} ));
                    elseif i_wvl == 2
                        out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),4} = num2str(wavelength(   mod(out_wvl3{opt3_count,i_mux},2)+1 ));
                    end
                    out_mtg3b{((opt3_count-1)*n_mux*n_wvl)+(((i_mux*n_wvl)-1)+(i_wvl-1))+mod(n_wvl,2),5} = num2str(modulation_f);
                    end
                end
            end
        end
        
        out_mtg = [out_mtg; out_mtg2b; out_mtg3b];
        
    end
    
    

    
end % i_mtg

for i_row = 3:length(out_mtg)
    out_mtg{i_row,1} = num2str(i_row-2);
end

mtg(1).out_mtg  = out_mtg;



