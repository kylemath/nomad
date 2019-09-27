%make_the_montage.m - Part of nomad - used to select sources and detectors
%in a loop - adopted from original code by Ed Maclin.

function make_the_montage

global mtg helm

%loop for montages
for i_mtg = 1:mtg(1).n_mtgs
    
    
    %----------------------------
    %% Set up the schematic
    %----------------------------------
    
    %Start with everything gray
    for ix=1:helm.n_rows
        if helm.sdy(ix) == 1
            helm.clr{ix}=helm.src_clr(1)*ones(size(helm.xyz{ix}));   % start with light gray
        else
            helm.clr{ix}=helm.det_clr(1)*ones(size(helm.xyz{ix}));
        end
    end
    
    % display the schematic
    [ph plot_i plot_handle]=    helm_draw_sch;
    helm.plot_handle = plot_handle;
    plot_handle
    plot_handle(end-1)
    plot_handle(end)
    subplot(1,2,1); title(['Place the ' num2str(mtg(i_mtg).n_dets) ' Detectors.'],'fontsize',12)
    
    %% initialized and reset everything
    
    
    mtg(i_mtg).dets_left = 1:mtg(i_mtg).n_dets; %list of unassigned detectors to remove from and add if right click
    
    mtg(i_mtg).det_sch_coords = [];
    mtg(i_mtg).det_sch_rc = [];
    mtg(i_mtg).det_labels = '';
    mtg(i_mtg).det_xyz = [];
    mtg(i_mtg).det_xy = [];
    mtg(i_mtg).det_i = [];
    mtg(i_mtg).det_helm_loc = [];
    mtg(i_mtg).used_dets = [];
    
    mtg(i_mtg).close_dets = zeros(mtg(i_mtg).n_srcs,mtg(i_mtg).n_dets);
    mtg(i_mtg).srcs_left = 1:mtg(i_mtg).n_srcs; %list of all sources for help with deletion
    
    mtg(i_mtg).src_sch_coords = [];
    mtg(i_mtg).src_sch_rc = [];
    mtg(i_mtg).src_labels = '';
    mtg(i_mtg).src_xyz = [];
    mtg(i_mtg).src_xy = [];
    mtg(i_mtg).src_i = [];
    mtg(i_mtg).src_helm_loc = [];
    mtg(i_mtg).src_dist = [];
    mtg(i_mtg).used_srcs = [];
    
    
    
    %--------------------
    %% select the detectors
    %--------------------
    while ~isempty(mtg(i_mtg).dets_left)   % loop through detectors      
      
        %get a mouse click
        [jx jy but] = helmet_mouse_ixy; % get clicked cordinates (dets only!)
        
        
        %assign detector info and update figure
        if but <= 2 %if it is a left click to add
            if helm.sdy(jx) == 2  %and a detector position
                if helm.clr{jx}(jy,:) ~= [0 0 0];    % if no detector already there
                    i_det = mtg(i_mtg).dets_left(1); %get the next unassigned detector slot
                    mtg(i_mtg).dets_left(1) = [];  %and remove it from the list
                    mtg(i_mtg).det_sch_coords(i_det,:)=helm.sch_coords{jx}(:,jy);               %det location in schematic's spatial coordinates
                    mtg(i_mtg).det_sch_rc(i_det,:) = [jx jy];                                   %the row and column in the schematic of the detector
                    mtg(i_mtg).det_labels(i_det,:)=[helm.labels(jx,:) sprintf('%02.0f',jy)];    %det location on helmet name from elp file
                    mtg(i_mtg).det_xyz(i_det,:)=helm.xyz{jx}(jy,:);                             %det xyz coordinates on the scalp
                    mtg(i_mtg).det_xy(i_det,:) = helm.xy{jx}(jy,:);                             %det location in scatter
                    mtg(i_mtg).det_i(i_det) = helm.sensor_i{jx}(jy);                          %for each det, number in elp list
                    mtg(i_mtg).det_helm_loc(mtg(i_mtg).det_i(i_det)) = i_det;                   %For each help location, which number detector is there
                    set(plot_i,'currentaxes',helm.plot_handle(end-1)) %update the scatterplot
                    scatter(mtg(i_mtg).det_xy(i_det,1),mtg(i_mtg).det_xy(i_det,2),helm.spot*2,[0 0 0])
                    scatter(mtg(i_mtg).det_xy(i_det,1),mtg(i_mtg).det_xy(i_det,2),helm.spot,[0 0 0],'filled')
                    set(plot_i,'currentaxes',helm.plot_handle(end)) %update the schematic
                    set(ph{jx}(jy),'FaceColor',[0 0 0]); % set clicked patch to black on drawing
                    helm.clr{jx}(jy,:)=[0 0 0];    % record selected detector as black
                    if length(mtg(i_mtg).dets_left) == 1
                        title(['There is ' num2str(length(mtg(i_mtg).dets_left)) ' detector remaining.'],'fontsize',12)
                    else
                        title(['There are ' num2str(length(mtg(i_mtg).dets_left)) ' detectors remaining.'],'fontsize',12)
                    end
                    % scan all locations and color srcs according to distance
                    for ix=1:helm.n_rows
                        for iy=1:helm.loc_per_row(ix)
                            temp_dist = helm.all_dist(helm.sensor_i{jx}(jy),helm.sensor_i{ix}(iy)); %get the distance from the distance lookup
                            if helm.type(ix)~=helm.type(jx) && temp_dist <= mtg(i_mtg).max_dist && temp_dist >= mtg(i_mtg).min_dist  % increment shade depending on distance
                                if helm.clr{ix}(iy,2) <= helm.clr{ix}(iy,1);
                                    helm.clr{ix}(iy,:)=helm.clr{ix}(iy,:) + [0 -(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets) -(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets)];
                                    if helm.clr{ix}(iy,2) < 0
                                        helm.clr{ix}(iy,2:3) = 0; %if it is saturated
                                    end
                                elseif helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1);  %if green
                                    helm.clr{ix}(iy,:)=helm.clr{ix}(iy,:) + [-(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets) 0 -(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets)];
                                    if helm.clr{ix}(iy,1) < 0
                                        helm.clr{ix}(iy,1:3) = 0;  %if it is saturated
                                    end
                                end
                            end
                            %for any srcs too close to detector, turn them to green
                            if helm.type(ix)~=helm.type(jx) && temp_dist < mtg(i_mtg).min_dist
                                if helm.clr{ix}(iy,2) <= helm.clr{ix}(iy,1);
                                    temp = helm.clr{ix}(iy,1);   % swith to make green
                                    helm.clr{ix}(iy,1) = helm.clr{ix}(iy,2);
                                    helm.clr{ix}(iy,2) = temp;
                                    if helm.clr{ix}(iy,2) == helm.clr{ix}(iy,1);
                                        helm.clr{ix}(iy,2) = helm.clr{ix}(iy,2) + eps;
                                    end
                                end
                            end
                        end % 'hole' loop
                    end % row loop
                    % reset schematic to current colors
                    for ix=1:helm.n_rows
                        for iy=1:helm.loc_per_row(ix)
                            if helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1)
                                set(ph{ix}(iy),'FaceColor',[1 1 1]);
                            else
                                set(ph{ix}(iy),'FaceColor',helm.clr{ix}(iy,:));
                            end
                        end
                    end
                end
            end %assign detector   
        
        
        elseif but == 3  && helm.sdy(jx) == 2 %if right click remove detector on a detector
            if helm.clr{jx}(jy,:) == [0 0 0];    % if a detector and already selected
               
                %id detector and remove all info
                temp_i = helm.sensor_i{jx}(jy);      %find index on list of all locations
                i_det = mtg(i_mtg).det_helm_loc(temp_i);  %find the detector number
                mtg(i_mtg).dets_left = [mtg(i_mtg).dets_left, i_det];  %and add it back to the list of choices
                mtg(i_mtg).det_helm_loc(temp_i) = 0; %remove from the list of all helmet locations detector locations
                temp_old_used = sort(mtg(i_mtg).det_helm_loc(mtg(i_mtg).det_helm_loc>0));
                mtg(i_mtg).used_dets = 1:length(temp_old_used); %create list of used detectors
                %must change the numbers in helm_loc to represent new order of dets used -DONE
                for i_new_det = 1:length(temp_old_used)
                    mtg(i_mtg).det_helm_loc(mtg(i_mtg).det_helm_loc == temp_old_used(i_new_det)) = i_new_det;
                end
                mtg(i_mtg).dets_left = length(mtg(i_mtg).used_dets)+1:mtg(i_mtg).n_dets;          %create new list of remaining detectors
                mtg(i_mtg).det_sch_coords(i_det,:) = [];    %remove that detectors information
                mtg(i_mtg).det_sch_rc(i_det,:) = [];
                mtg(i_mtg).det_labels(i_det,:) = [];
                mtg(i_mtg).det_xyz(i_det,:) = [];
                mtg(i_mtg).det_xy(i_det,:) = [];
                mtg(i_mtg).det_i(i_det) = [];
               
                
                %redraw and update the scatterplot
                set(plot_i,'currentaxes',helm.plot_handle(end-1)) %update the scatterplot
                hold off
                scatter(helm.sensor_xy(:,1),helm.sensor_xy(:,2),helm.spot,helm.sensor_clr,'filled'); axis off; hold on;
                scatter(mtg(i_mtg).det_xy(:,1),mtg(i_mtg).det_xy(:,2),helm.spot,[0 0 0],'filled');
                scatter(mtg(i_mtg).det_xy(:,1),mtg(i_mtg).det_xy(:,2),helm.spot*2,[0 0 0]);
                %update the schematic
                set(plot_i,'currentaxes',helm.plot_handle(end)) %update the schematic
                set(ph{jx}(jy),'FaceColor',helm.det_clr); % set clicked patch to gray
                helm.clr{jx}(jy,:)=helm.det_clr;    % record selected detector as gray
                if length(mtg(i_mtg).dets_left) == 1
                    title(['There is ' num2str(length(mtg(i_mtg).dets_left)) ' detector remaining.'],'fontsize',12)
                else
                    title(['There are ' num2str(length(mtg(i_mtg).dets_left)) ' detectors remaining.'],'fontsize',12)
                end
                % scan all locations and uncolor srcs according to distance (This should work backwards here to remove) - DOES
                for ix=1:helm.n_rows
                    for iy=1:helm.loc_per_row(ix)
                        temp_dist = helm.all_dist(helm.sensor_i{jx}(jy),helm.sensor_i{ix}(iy)); %get the distance from the distance lookup
                        %increment shading depending on distance
                        if helm.type(ix)~=helm.type(jx) && temp_dist <= mtg(i_mtg).max_dist && temp_dist >= mtg(i_mtg).min_dist
                            if helm.clr{ix}(iy,2) < helm.clr{ix}(iy,1);  %If this is a red spot
                                helm.clr{ix}(iy,:)=helm.clr{ix}(iy,:) + [0 +(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets) +(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets)];
                                if helm.clr{ix}(iy,2) > helm.src_clr(1) %if it is back to grey
                                    helm.clr{ix}(iy,2:3) = helm.src_clr(1);
                                end
                            elseif helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1); %if this is a green spot
                                helm.clr{ix}(iy,:)=helm.clr{ix}(iy,:) + [+(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets) 0 +(1-(temp_dist/(mtg(i_mtg).max_dist*1.5)))/(mtg(i_mtg).n_dets)];
                                if helm.clr{ix}(iy,1) > helm.src_clr(2) %if it is back to grey from taking off too much red
                                    helm.clr{ix}(iy,1:3) = helm.src_clr(2);
                                end
                            end
                        end
                        %remove the green and turn back to red, only if the spot isn't near other detectors
                        if helm.type(ix)~=helm.type(jx) && temp_dist < mtg(i_mtg).min_dist  %for any srcs too close to detector
                            %find if not near any more detectors
                            now_clear = 1;
                            for i_det_rem = mtg(i_mtg).used_dets
                                if helm.all_dist(mtg(i_mtg).det_i(i_det_rem),helm.sensor_i{ix}(iy)) < mtg(i_mtg).min_dist
                                    now_clear = 0;
                                end
                            end
                            %if no longer near any detectors
                            if now_clear == 1
                                if helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1);
                                    temp = helm.clr{ix}(iy,2);   % swith back to red only if green
                                    helm.clr{ix}(iy,2) = helm.clr{ix}(iy,1);
                                    helm.clr{ix}(iy,1) = temp;
                                end
                            end
                        end
                    end % 'hole' loop
                end % row loop
                % reset schematic to current colors
                for ix=1:helm.n_rows
                    for iy=1:helm.loc_per_row(ix)
                        if helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1)     % if Green - to close
                            set(ph{ix}(iy),'FaceColor',[1 1 1]);
                        elseif helm.clr{ix}(iy,3) > helm.clr{ix}(iy,1);   % If blue - source
                            set(ph{ix}(iy),'FaceColor',[0 0 1]);
                        else
                            set(ph{ix}(iy),'FaceColor',helm.clr{ix}(iy,:));
                        end
                    end
                end
            end %remove detector
        end 
        
        
        
    end % define detectors
    
    
    
    
    %--------------------
    %% select the sources
    %--------------------
    
    
    
    
    
    
    %script to add the sources manually
    if mtg(i_mtg).auto_srcs == 0
        title(['Great now place the ' num2str(mtg(i_mtg).n_srcs) ' sources.'],'fontsize',12);
        while ~isempty(mtg(i_mtg).srcs_left)  % for each source
            
            
            %Find the match in each row and the max overall, stop if no acceptablle locations remain
            row_max = [];
            for i_row = 1:helm.n_rows
                [row_max(i_row,1) row_max(i_row,2)] = max(helm.clr{i_row}(:,1)-helm.clr{i_row}(:,2));
            end
            [a kx] = max(row_max(:,1));
            ky = row_max(kx,2);
            if helm.clr{kx}(ky,1) == helm.clr{kx}(ky,2); %if the best left is a grey area
                set(plot_i,'currentaxes',helm.plot_handle(end))
                title(['No acceptable positions left for the ' num2str(length(mtg(i_mtg).srcs_left)) ' sources left, Restart',],'fontsize',15);
                break;
            end
            
            %get a mouse click
            [jx jy but] = helmet_mouse_ixy; % get clicked cordinates (dets only!)
            
            
            if helm.sdy(jx) == 1 && but == 1
                if helm.clr{jx}(jy,1) > helm.clr{jx}(jy,3);   %if this source is still red and unselected
                    i_src = mtg(i_mtg).srcs_left(1); %get the next unassigned detector slot
                    mtg(i_mtg).srcs_left(1) = [];  %and remove it from the list
                    
                    %record important information
                    mtg(i_mtg).src_sch_coords(i_src,:)=helm.sch_coords{jx}(:,jy);                   % corrdinates in the schematic
                    mtg(i_mtg).src_sch_rc(i_src,:) = [jx jy];                                       %row and column in the schematic
                    mtg(i_mtg).src_xyz(i_src,:)=helm.xyz{jx}(jy,:);                                 %xyz coordinates of the source location on the scalp
                    mtg(i_mtg).src_xy(i_src,:) =helm.xy{jx}(jy,:);                                  %coordinates in the scatterplot flatmpa
                    mtg(i_mtg).src_labels(i_src,:)=[helm.labels(jx,:) sprintf('%02.0f',jy)];        %labels in the helmet of this source location
                    mtg(i_mtg).src_i(i_src) = helm.sensor_i{jx}(jy);                                %det number in elp list
                    mtg(i_mtg).src_helm_loc(mtg(i_mtg).src_i(i_src)) = i_src;                       %list of all the helmet locations and the detector number they have for undo function
                   
                    % scan detectors to determine close_dets
                    for i_det=1:size(mtg(i_mtg).det_sch_coords,1)    % scan dets
                        %get distance between this source and each detector from lookup table
                        mtg(i_mtg).src_dist(i_det,i_src) = helm.all_dist(mtg(i_mtg).src_i(i_src),mtg(i_mtg).det_i(i_det));
                        if mtg(i_mtg).src_dist(i_det,i_src) < mtg(i_mtg).max_dist  % if this det is close enough..
                            mtg(i_mtg).close_dets(i_src,i_det)=1;  %stash it for adding selected mux # below
                        end
                    end % i_det
                    
                    %if any detectors near this source now have the max number 
                    %of possible srcs based on the number of muxs then make all of them unselectable
                    for i_det = find(mtg(i_mtg).close_dets(i_src,:) == 1)  %for all the close dets
                        if length(find(mtg(i_mtg).close_dets(:,i_det)) == 1) == mtg(i_mtg).n_muxs  %if they reached the max mux
                            %cycle through all the location and find close sources
                            for ix=1:helm.n_rows
                                for iy=1:helm.loc_per_row(ix)
                                    temp_dist = helm.all_dist(mtg(i_mtg).det_i(i_det),helm.sensor_i{ix}(iy)); %lookup distance
                                    if helm.clr{ix}(iy,1) > helm.clr{ix}(iy,3) %if this was a red selectable source
                                        if helm.type(ix) == helm.type(jx) && temp_dist <= mtg(i_mtg).max_dist && temp_dist >= mtg(i_mtg).min_dist % change shade to grey for all within range
                                            helm.clr{ix}(iy,1) = helm.clr{ix}(iy,2);
                                            %                                             set(ph{ix}(iy),'FaceColor',helm.clr{ix}(iy,:)); % set clicked patch to unselectable grey
                                            set(ph{ix}(iy),'FaceColor',helm.src_clr); % set clicked patch to unselectable white
                                        end
                                    end
                                end % 'hole' loop
                            end % row loop
                        end
                    end %all close dets
                          
                    % update the schematic
                    set(plot_i,'currentaxes',helm.plot_handle(end))
                    hold on
                    temp = helm.clr{jx}(jy,1);   % swith to make blue
                    helm.clr{jx}(jy,1) = helm.clr{jx}(jy,3);
                    helm.clr{jx}(jy,3) = temp;
                    % set(ph{jx}(jy),'FaceColor',helm.clr{jx}(jy,:)); % set clicked patch to blue
                    set(ph{jx}(jy),'FaceColor',[0 0 1]); % set clicked patch to blue
                    if length(mtg(i_mtg).dets_left) == 1
                        title(['There is ' num2str(length(mtg(i_mtg).srcs_left)) ' source remaining.'],'fontsize',12)
                    else
                        title(['There are ' num2str(length(mtg(i_mtg).srcs_left)) ' sources remaining.'],'fontsize',12)
                    end
                    
                    %update scatterplot
                    set(plot_i,'currentaxes',helm.plot_handle(end-1))
                    scatter(mtg(i_mtg).src_xy(i_src,1),mtg(i_mtg).src_xy(i_src,2),helm.spot,[1 0 0],'filled')
                    scatter(mtg(i_mtg).src_xy(i_src,1),mtg(i_mtg).src_xy(i_src,2),helm.spot,[0 0 0])
                    %plot a line connecting the source to the detectors nearby
                    for i_det=find(mtg(i_mtg).close_dets(i_src,:) == 1)
                        if mtg(i_mtg).src_dist(i_det,i_src)>mtg(i_mtg).min_dist && mtg(i_mtg).src_dist(i_det,i_src)<=mtg(i_mtg).max_dist
                            plot([mtg(i_mtg).src_xy(i_src,1) mtg(i_mtg).det_xy(i_det,1)],[mtg(i_mtg).src_xy(i_src,2) mtg(i_mtg).det_xy(i_det,2)],'Color',[(mtg(i_mtg).src_dist(i_det,i_src)/mtg(i_mtg).max_dist) 0 0],'LineWidth',2)
                        end
                    end
                end %add source
                
                
                
                
                
                
                
                
                
%             elseif but == 3  && helm.sdy(jx) == 1 %if right click remove source
%                 if helm.clr{jx}(jy,3) > helm.clr{jx}(jy,1);    % if a source and already selected
%                     
%                     %id and remove info about the source that was added
%                     temp_i = helm.sensor_i{jx}(jy);      %find index on list of all locations
%                     i_src = mtg(i_mtg).src_helm_loc(temp_i);    %find src number attached to that position
%                     mtg(i_mtg).srcs_left = [mtg(i_mtg).srcs_left, i_src];  %and add it back to the list of choices
%                    
%                     %adjust helm_loc
%                     mtg(i_mtg).src_helm_loc(temp_i) = 0;    %adjust close_dets
%                     mtg(i_mtg).close_dets(i_src,:) = 0; %take it off the list of close srcs to that each detector
%                
%                     temp_old_used_src = sort(mtg(i_mtg).src_helm_loc(mtg(i_mtg).src_helm_loc>0));
%                     mtg(i_mtg).used_srcs = 1:length(temp_old_used_src);
%                     %change numbers in helm_loc
%                     for i_new_src = 1:length(temp_old_used_src)
%                         mtg(i_mtg).src_helm_loc(mtg(i_mtg).src_helm_loc == temp_old_used_src(i_new_src)) = i_new_src;
%                         mtg(i_mtg).close_dets(i_new_src,:) = mtg(i_mtg).close_dets(temp_old_used_src(i_new_src),:);
%                         if i_new_src ~= temp_old_used_src(i_new_src)
%                             mtg(i_mtg).close_dets(temp_old_used_src(i_new_src),:) = 0;
%                         end
%                     end                                                   
%                     mtg(i_mtg).srcs_left = length(mtg(i_mtg).used_srcs)+1:mtg(i_mtg).n_srcs;                 
%                     mtg(i_mtg).src_sch_coords(i_src,:) = [];    %remove that detectors information
%                     mtg(i_mtg).src_sch_rc(i_src,:) = [];
%                     mtg(i_mtg).src_labels(i_src,:) = [];
%                     mtg(i_mtg).src_xyz(i_src,:) = [];
%                     mtg(i_mtg).src_xy(i_src,:) = [];
%                     mtg(i_mtg).src_i(i_src) = [];  
%                     mtg(i_mtg).src_dist(:,i_src) = []; %take this info away
%                     %search through the detectors near that source and give
%                     %them their red colour back if they will now have less
%                     %than mux number of sources...
%                     for i_det = find(mtg(i_mtg).close_dets(i_src,:) == 1) %find all dets near that sours
%                         if length(find(mtg(i_mtg).close_dets(:,i_det)) == 1) == mtg(i_mtg).n_muxs-1 %if = n_muxs then removing this will put it back to red
%                             for ix=1:helm.n_rows
%                                 for iy=1:helm.loc_per_row(ix)
%                                     temp_dist = helm.all_dist(mtg(i_mtg).det_i(i_det),helm.sensor_i{ix}(iy));
%                                     %return to red if grey hole?
%                                     if helm.clr{ix}(iy,1) == helm.clr{ix}(iy,2) && helm.clr{ix}(iy,3) == helm.clr{ix}(iy,2) %if this is a greyed out hole
%                                         if helm.type(ix) == helm.type(jx) && temp_dist <= mtg(i_mtg).max_dist && temp_dist >= mtg(i_mtg).min_dist % increment shade depending on distance
%                                             if helm.clr{ix}(iy,3) <= helm.clr{ix}(iy,1)
%                                             helm.clr{ix}(iy,1) = helm.src_clr(1);
%                                             set(ph{ix}(iy),'FaceColor',helm.clr{ix}(iy,:)); % return the path to red - (make red the largest)
%                                             end
%                                         end
%                                     end
%                                 end % 'hole' loop
%                             end % row loop
%                         end
%                     end
%                    %update the scatterplot
%                     set(plot_i,'currentaxes',helm.plot_handle(end-1)) 
%                     hold off
%                     scatter(helm.sensor_xy(:,1),helm.sensor_xy(:,2),helm.spot,helm.sensor_clr,'filled'); axis off; hold on;
%                     scatter(mtg(i_mtg).src_xy(:,1),mtg(i_mtg).src_xy(:,2),helm.spot,[0 0 0]);
%                     scatter(mtg(i_mtg).det_xy(:,1),mtg(i_mtg).det_xy(:,2),helm.spot,[0 0 0],'filled');
%                     scatter(mtg(i_mtg).det_xy(:,1),mtg(i_mtg).det_xy(:,2),helm.spot*2,[0 0 0]);
%                     %draw the connecting lines
%                     for i_src = mtg(i_mtg).used_srcs
%                         for i_det=find(mtg(i_mtg).close_dets(i_src,:) == 1)
%                             if mtg(i_mtg).src_dist(i_det,i_src)>mtg(i_mtg).min_dist && mtg(i_mtg).src_dist(i_det,i_src)<=mtg(i_mtg).max_dist
%                                 plot([mtg(i_mtg).src_xy(i_src,1) mtg(i_mtg).det_xy(i_det,1)],[mtg(i_mtg).src_xy(i_src,2) mtg(i_mtg).det_xy(i_det,2)],'Color',[(mtg(i_mtg).src_dist(i_det,i_src)/mtg(i_mtg).max_dist) 0 0],'LineWidth',2)
%                             end
%                         end
%                     end
%                     %update schematic
%                     set(plot_i,'currentaxes',helm.plot_handle(end)) %update the schematic
%                     temp = helm.clr{jx}(jy,1);   % switch the source from blue back to red
%                     helm.clr{jx}(jy,1) = helm.clr{jx}(jy,3);
%                     helm.clr{jx}(jy,3) = temp;
%                     set(ph{jx}(jy),'FaceColor',helm.clr{jx}(jy,:)); % set clicked patch to assing color       
%                     if length(mtg(i_mtg).srcs_left) == 1
%                         title(['There is ' num2str(length(mtg(i_mtg).srcs_left)) ' source remaining.'],'fontsize',12)
%                     else
%                         title(['There are ' num2str(length(mtg(i_mtg).srcs_left)) ' sources remaining.'],'fontsize',12)
%                     end   
%                     for ix=1:helm.n_rows
%                         for iy=1:helm.loc_per_row(ix)
%                             if helm.clr{ix}(iy,2) > helm.clr{ix}(iy,1)
%                                 set(ph{ix}(iy),'FaceColor',[1 1 1]);
%                             elseif helm.clr{ix}(iy,3) > helm.clr{ix}(iy,1)
%                                 set(ph{ix}(iy),'FaceColor',[0 0 1]);
%                             else
%                                 set(ph{ix}(iy),'FaceColor',helm.clr{ix}(iy,:));
%                             end
%                         end
%                     end
%                     
%                 end %end undo
                
                
                
            end
            
            
            
            
            
            
        end     % n_srcs
        
        
        
        
        
        
        
        
        
        
        
        
%         Script to automatically select sources based on colouring from detectors
            elseif mtg(i_mtg).auto_srcs == 1
                title('Automatic Source Selection','fontsize',12);
                mtg(i_mtg).close_dets = zeros(mtg(i_mtg).n_srcs,mtg(i_mtg).n_dets);
                for i_src = 1:mtg(i_mtg).n_srcs
                    %Find the max in each row and the max overall
                    row_max = [];
                    for i_row = 1:helm.n_rows
                        [row_max(i_row,1) row_max(i_row,2)] = max(helm.clr{i_row}(:,1)-helm.clr{i_row}(:,2));
                    end
                    [a jx] = max(row_max(:,1));
                    jy = row_max(jx,2);
                    if helm.clr{jx}(jy,1) == helm.clr{jx}(jy,2); %if the best left is a grey area
                        set(plot_i,'currentaxes',helm.plot_handle(end))
                        title(['No acceptable positions left for the ' num2str(mtg(i_mtg).n_srcs-i_src+1) ' sources left, Restart'],'fontsize',15);
                        crowded_flag = 1;
                        break;
                    end
                    mtg(i_mtg).src_sch_coords(i_src,:)=helm.sch_coords{jx}(:,jy);    % for labeling & drawing lines
                    mtg(i_mtg).src_sch_rc(i_src,:) = [jx jy];
                    mtg(i_mtg).src_xyz(i_src,:)=helm.xyz{jx}(jy,:);
                    mtg(i_mtg).src_xy(i_src,:) =helm.xy{jx}(jy,:);
                    mtg(i_mtg).src_labels(i_src,:)=[helm.labels(jx,:) sprintf('%02.0f',jy)];
                    % scan detectors to determine close_dets
                    for i_det=1:size(mtg(i_mtg).det_sch_coords,1)    % scan dets
                        dx=mtg(i_mtg).src_xyz(i_src,1)-mtg(i_mtg).det_xyz(i_det,1);
                        dy=mtg(i_mtg).src_xyz(i_src,2)-mtg(i_mtg).det_xyz(i_det,2);
                        dz=mtg(i_mtg).src_xyz(i_src,3)-mtg(i_mtg).det_xyz(i_det,3);
                        mtg(i_mtg).src_dist(i_det,i_src)=sqrt(dx^2+dy^2+dz^2);
                        if mtg(i_mtg).src_dist(i_det,i_src) < mtg(i_mtg).max_dist  % if this det is close enough to get any light
                            mtg(i_mtg).close_dets(i_src,i_det)=1; %stash it for adding selected mux # below
                        end
                    end % i_det
                    % draw connecting schematic lines
                    set(plot_i,'currentaxes',helm.plot_handle(end))
                    hold on
                    temp = helm.clr{jx}(jy,1);   % swith to make blue
                    helm.clr{jx}(jy,1) = helm.clr{jx}(jy,3);
                    helm.clr{jx}(jy,3) = temp;
                    set(ph{jx}(jy),'FaceColor',helm.clr{jx}(jy,:)); % set clicked patch to blue
                    %if this detector now has the max number of possible srcs based on the number of muxs
                    for i_det = find(mtg(i_mtg).close_dets(i_src,:) == 1)
                        if length(find(mtg(i_mtg).close_dets(:,i_det)) == 1) == mtg(i_mtg).n_muxs
                            for ix=1:helm.n_rows
                                for iy=1:length(helm.xyz{ix})
                                    dx=mtg(i_mtg).det_xyz(i_det,1)-helm.xyz{ix}(iy,1);
                                    dy=mtg(i_mtg).det_xyz(i_det,2)-helm.xyz{ix}(iy,2);
                                    dz=mtg(i_mtg).det_xyz(i_det,3)-helm.xyz{ix}(iy,3);
                                    dist(ix,iy)=sqrt(dx^2+dy^2+dz^2);
                                    if helm.clr{ix}(iy,1) > helm.clr{ix}(iy,3) %if this isnt a src hole
                                        if helm.type(ix) == helm.type(jx) && dist(ix,iy) <= mtg(i_mtg).max_dist && dist(ix,iy) >= mtg(i_mtg).min_dist % increment shade depending on distance
                                            helm.clr{ix}(iy,:)= helm.src_clr;
                                            set(ph{ix}(iy),'FaceColor',helm.src_clr); % set clicked patch to unselectable grey
                                        end
                                    end
                                end % 'hole' loop
                            end % row loop
                        end
                    end
                    set(plot_i,'currentaxes',helm.plot_handle(end-1))
                    scatter(mtg(i_mtg).src_xy(i_src,1),mtg(i_mtg).src_xy(i_src,2),helm.spot,[1 0 0],'filled')
                    scatter(mtg(i_mtg).src_xy(i_src,1),mtg(i_mtg).src_xy(i_src,2),helm.spot,[0 0 0])
                    for i_det=find(mtg(i_mtg).close_dets(i_src,:) == 1)
                        if mtg(i_mtg).src_dist(i_det,i_src)>mtg(i_mtg).min_dist && mtg(i_mtg).src_dist(i_det,i_src)<=mtg(i_mtg).max_dist %draw the red line
                            plot([mtg(i_mtg).src_xy(i_src,1) mtg(i_mtg).det_xy(i_det,1)],[mtg(i_mtg).src_xy(i_src,2) mtg(i_mtg).det_xy(i_det,2)],'Color',[(mtg(i_mtg).src_dist(i_det,i_src)/mtg(i_mtg).max_dist) 0 0],'LineWidth',2)
                        end
                    end
                end %sources
        
        
    end  %if auto
end  %i_mtg






