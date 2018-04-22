% scrsz = get(0,'ScreenSize');
% fig1=figure('Position',[0 0 scrsz(3)/1.1 scrsz(4)/1.1],'Color','w');
function MathewsonMuxCheck

    global mtg helm
    
    good_mtg_flag = 1; %if its a good mtg
    cross_count = 0;
    %E_mat is a matrix (n_srcs,n_srcs) that is 1 if the two sources are within
    %the range of any number >= 1 detectors (ie. are members of a clique; ie.
    %would cross talk if given the same mux numbers
    figure; imagesc(mtg(mtg(1).current).E_mat); hold on; axis square;
    for i_mux = 1:16 %for every mux number
        %find all the sources assigned that number
        inds = find(mtg(mtg(1).current).mux_numbers == i_mux);
        %count them
        group_membs = length(inds);
        
        %if only 1 - no problem, else check:
        if group_membs > 1
            %only need one side of the symetric matrix
            for i_group = 1:group_membs-1
                for i_pair  = i_group + 1:group_membs
                    %plot all the pairs that share a mux number
                    scatter(inds(i_group),inds(i_pair),'k','.');
                    %if two of the same mux number are in the range of a detector
                    if mtg(mtg(1).current).E_mat(inds(i_group),inds(i_pair)) == 1
                        %flag as bad
                        scatter(inds(i_group),inds(i_pair),'w','.');
                        scatter(inds(i_pair),inds(i_group),'w','.');

                        text(inds(i_pair)+1,inds(i_group),[mtg(mtg(1).current).src_labels(inds(i_pair),:) ' , ' mtg(mtg(1).current).src_labels(inds(i_group),:)],'Color','w');
                        
                        cross_count = cross_count + 1;
                        good_mtg_flag = 0;
                        title(['!!!!! Bad Montage !!! - ' num2str(cross_count*2) ' sources with crosstalk!!!!!!!!!!']);
                    end
                end
            end
        end
    end
    if good_mtg_flag == 1
        title('GOOD MONTAGE :)');
    end
   
    
    
   good_mtg_flag = 1; %if its a good mtg

    CLim = [15 60];
   figure;
       colormap('bone');

    for i_mux = 1:16
        subplot(6,4,i_mux);
        inds = find(mtg(mtg(1).current).mux_numbers == i_mux);
        %count them
        group_membs = length(inds);
        imagesc(mtg(mtg(1).current).src_dist(:,inds)',CLim); title(['Mux ' num2str(i_mux)]);
        
        clear labels3
        for i=1:mtg(mtg(1).current).n_dets
            labels3{i} = mtg(mtg(1).current).det_name(i);
        end
        
        set(gca,'XTick',1:mtg(mtg(1).current).n_dets)
        set(gca,'XTickLabel',labels3)
        
        
        current_mux = mtg(mtg(1).current).src_dist(:,inds);
                
        for i_det = 1:size(current_mux,1)
            close_mux = find(current_mux(i_det,:) < mtg(1).max_dist);
            n_close_mux = length(close_mux);
            if n_close_mux > 1
                line([i_det i_det],[1 4],'Color','r');
                top_two = current_mux(i_det,close_mux(1:2));
                cross_ratio = max(top_two)/min(top_two);
                cross_diff = max(top_two)-min(top_two);
                text(i_det+.1,4.1,num2str(round(cross_diff)),'Color','r');
                good_mtg_flag = 0;
                title(['Cross Talk on this Mux: ' num2str(i_mux)]);
            end
        end
        
    end
    subplot(6,4,22:23); imagesc(mtg(mtg(1).current).src_dist(:,inds)',CLim);
    title('Legend');
    xlabel('Detector');
    ylabel('MuxReplicate');
    t = colorbar;
    set(get(t,'ylabel'),'String', 'Distance (mm)');

    
    
    
    
    
    
    
end


