% helm_draw_mtg(mtg(1).current).m -
% draw the coloured mtg after mux assignment

% Updated March 28, 2012 by Kyle Mathewson, Beckman Institute


function fig1 = helm_draw_mtg_out

global helm mtg


%------------------
%% set the labels for each detectors -
%------------------

%******This is also where oxiplex machines are separated, one has capital
%latters and one is lowercase, the order represent the order you will
%select detector locations
%the x's are for trying out more than the normal number of detectors


%CNL
% Opt2: 16 detectors, color-coded brown (opt2 is the trigger machine)
% Opt3: 8 detectors, color-coded grey

%DOIL
% Doil1: 8 detectors, color-coded grey (doil1 is the trigger)
% Doil2: 16 detectors, color-coded brown

if strcmp(mtg(mtg(1).current).schem_clr, 'CNL') == 1 || strcmp(mtg(mtg(1).current).schem_clr, 'Custom') %The trigger machine has capitols
    mtg(mtg(1).current).det_name = 'mnopABCDEFGHefghabcdijklxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';    % detector labels
elseif strcmp(mtg(mtg(1).current).schem_clr,'DOIL') == 1
    mtg(mtg(1).current).det_name = 'EFGHefghmnopijklabcdABCDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';    % detector labels
elseif strcmp(mtg(1).schem_clr,'APPLAB') == 1
    mtg(mtg(1).current).det_name = 'ABCDEFGHIJKLMNOPQRSTUVWXYZxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
end
mtg(mtg(1).current).det_name(mtg(mtg(1).current).n_dets+1:end) = [];





dx=helm.dx;
dy=helm.dy;

% draw the schematic

scrsz = get(0,'ScreenSize');
fig1=figure('Position',[1 1 scrsz(3)/1.1 scrsz(4)/1.1],'Color',[.8 .8 .8]);
axis off


for jx=1:helm.n_rows
    if helm.type(jx)=='S' % assign the colour for the row
        clr=helm.src_clr;
    else
        clr=helm.det_clr;
    end
    
    
    ix=helm.sch_coords{jx}(1,1);  %gets the horizontal position
    for jy=1:length(helm.sch_coords{jx}) %for each in the row
        
        iy=helm.sch_coords{jx}(2,jy); %gets the Y position
        
        x=[dx*(ix-1) dx*(ix-1) dx*ix dx*ix];  %bottom left, top left, top right, bottom right
        y=helm.sdy(jx)*[dy*(iy-1) dy*iy dy*iy dy*(iy-1)];  %makes it extended vertically if detector.
        ph{jx}(jy)=patch(x,y,clr);  %draws a patch on the image
    end
end


%% label the top of each row
for ix=1:helm.n_rows
    x=helm.sch_coords{ix}(1,1)-.6;
    y=(helm.sch_coords{ceil(helm.n_rows/2)}(2,1)*2)+1;
    text(x,y,helm.labels(ix,:),'Color','k','fontsize',12);  
    for iy=1:length(helm.xyz{ix})
        set(ph{ix}(iy),'FaceColor',[1 1 1]);
    end
end

%Label the src holes
for i_src = 1:mtg(mtg(1).current).n_srcs
    set(ph{mtg(mtg(1).current).src_sch_rc(i_src,1)}(mtg(mtg(1).current).src_sch_rc(i_src,2)),'FaceColor',[1 1 0]);
    %         x=mtg(mtg(1).current).src_sch_coords(i_src,1)-.5;
    %         y=2*mtg(mtg(1).current).src_sch_coords(i_src,2)-1;
    %         text(x,y,num2str(mtg(mtg(1).current).mux_numbers(i_src,1)),'Color','k');  % label the source patch
    %
    
%     if mod(mtg(mtg(1).current).src_sch_rc(i_src,2),10) == 0 || mod(mtg(mtg(1).current).src_sch_rc(i_src,2),5) == 0 || mtg(mtg(1).current).src_sch_rc(i_src,2) == 1
                    %label the next hole over with the column number
                    x=mtg(mtg(1).current).src_sch_coords(i_src,1)+.2; %.2/1.3 on other side
                    y=2*mtg(mtg(1).current).src_sch_coords(i_src,2)-.85;
                    text(x,y,num2str(mtg(mtg(1).current).src_sch_rc(i_src,2)),'Color','k','fontsize',8);  % label the source row number
%     end
end

%THis is a code to colour the mux channels in groups based on coloumn
%then row to be near the other muxs from that bank

if mtg(mtg(1).current).n_wvls == 1
    
    if strcmp(mtg(mtg(1).current).schem_clr,'CNL') == 1 
        mtg(mtg(1).current).bank_clrs = [.5 .2 .5;  1 .6 .8; .5 .37 0;  .82 .82 .82;  1 0 0; 0 1 0; 0 0 1; .8 .2 .2] ;   %the different colours, green,blue,pink,purple
    elseif strcmp(mtg(mtg(1).current).schem_clr,'DOIL') == 1
        mtg(mtg(1).current).bank_clrs = [ .5 .37 0;  1 .6 .8; .82 .82 .82; .5 .2 .5; 1 0 0; 0 1 0; 0 0 1; .8 .2 .2] ;  %the different colours, purple, grey, pink, brown
    elseif strcmp(mtg(mtg(1).current).schem_clr,'Custom') == 1 && mtg(mtg(1).current).bank_choose == 0
        mtg(mtg(1).current).bank_clrs = ones(4,3) * .9; %make everything grey until the schematic maker
    elseif strcmp(mtg(mtg(1).current).schem_clr,'APPLAB') == 1
        mtg(mtg(1).current).bank_clrs = [1 0 0;  0 1 0; 0 0 1;  .5 .5 0;  .5 0 0; 0 .5 0; 0 0 .5; .8 .2 .2] ;  %
    end
    
elseif mtg(mtg(1).current).n_wvls == 2
    
    if strcmp(mtg(mtg(1).current).schem_clr,'CNL') == 1
        mtg(mtg(1).current).bank_clrs = [.5 .2 .5; .4 .4 .8; .5 .2 .5; 0 1 0] ;  %the different colours, green,blue,pink,purple
    elseif strcmp(mtg(mtg(1).current).schem_clr,'DOIL') == 1
        mtg(mtg(1).current).bank_clrs = [ .5 .37 0; .82 .82 .82; .5 .2 .5; 0 1 0] ;  %the different colours, purple, grey, pink, brown
    elseif strcmp(mtg(mtg(1).current).schem_clr,'Custom') == 1 && mtg(mtg(1).current).bank_choose == 0
        mtg(mtg(1).current).bank_clrs = ones(4,3) * .9; %make everything grey until the schematic maker
    elseif strcmp(mtg(mtg(1).current).schem_clr,'APPLAB') == 1
         mtg(mtg(1).current).bank_clrs = [1 0 0;  0 1 0; 0 0 1;  .5 .5 0] ;  %
    end
    
end

source_order =  10*mtg(mtg(1).current).src_sch_rc(:,1) + mtg(mtg(1).current).src_sch_rc(:,2);   %number srcs based on row and column
[a source_order] = sort(source_order); %rearange the sources in order of their rows than columns from top left to bottom right
%     det_order = 10*mtg(mtg(1).current).det_sch_rc(:,1) + mtg(mtg(1).current).det_sch_rc(:,2); %number detectors
%     [a det_order] = sort(det_order);



%This colours the srcs based on vertical patches representing each src/det bank

picked_srcs = zeros(1,mtg(mtg(1).current).n_srcs);
for i_bank = 1:mtg(mtg(1).current).n_banks
    for i_mux = 1:mtg(mtg(1).current).n_muxs;
        for i_src = 1:mtg(mtg(1).current).n_srcs
            next_src = source_order(i_src);
            
            
            if mtg(mtg(1).current).mux_numbers(next_src,1) == i_mux && picked_srcs(next_src) ~= 1
                
                picked_srcs(next_src) = 1;
                
                
                if mtg(mtg(1).current).n_wvls == 2
                    set(ph{mtg(mtg(1).current).src_sch_rc(next_src,1)}(mtg(mtg(1).current).src_sch_rc(next_src,2)),'FaceColor',mtg(mtg(1).current).bank_clrs(ceil(i_bank/2),:));
                else
                    set(ph{mtg(mtg(1).current).src_sch_rc(next_src,1)}(mtg(mtg(1).current).src_sch_rc(next_src,2)),'FaceColor',mtg(mtg(1).current).bank_clrs(i_bank,:));
                end
                
                x=mtg(mtg(1).current).src_sch_coords(next_src,1)-.5;
                y=2*mtg(mtg(1).current).src_sch_coords(next_src,2)-1;
                
                
                
                if mtg(mtg(1).current).n_wvls == 2
                    
                    if mean(mtg(mtg(1).current).bank_clrs(ceil(i_bank/2),:)) < .5
                        text(x,y,num2str((2*mtg(mtg(1).current).mux_numbers(next_src,1))-mod(i_bank,2)),'Color','w');  % label the source patch
                        mtg(mtg(1).current).mux_numbers_wvl(next_src) = (2*mtg(mtg(1).current).mux_numbers(next_src,1))-mod(i_bank,2);
                    else
                        text(x,y,num2str((2*mtg(mtg(1).current).mux_numbers(next_src,1))-mod(i_bank,2)),'Color','k');  % label the source patch
                        mtg(mtg(1).current).mux_numbers_wvl(next_src) = (2*mtg(mtg(1).current).mux_numbers(next_src,1))-mod(i_bank,2);
                        
                    end
                    
                else
                    
                    if mean(mtg(mtg(1).current).bank_clrs(i_bank,:)) < .5
                        text(x,y,num2str(mtg(mtg(1).current).mux_numbers(next_src,1)),'Color','w');  % label the source patch
                    else
                        text(x,y,num2str(mtg(mtg(1).current).mux_numbers(next_src,1)),'Color','k');  % label the source patch
                    end
                end
                
                break
            end
        end
    end
end


%This colours the detectors based on the detector banks

for i_det = 1:mtg(mtg(1).current).n_dets
    if mtg(mtg(1).current).det_name(i_det) < 'a' %If it is a capitol letter from the trigger machine
        set(ph{mtg(mtg(1).current).det_sch_rc(i_det,1)}(mtg(mtg(1).current).det_sch_rc(i_det,2)),'FaceColor',[.3 .3 .3] );
        x=mtg(mtg(1).current).det_sch_coords(i_det,1)-.5;
        y=4*mtg(mtg(1).current).det_sch_coords(i_det,2)-1;
        text(x,y,mtg(mtg(1).current).det_name(i_det),'Color',[1 1 1],'fontsize',12);  % label the detector patch
    else %from the second machine
        set(ph{mtg(mtg(1).current).det_sch_rc(i_det,1)}(mtg(mtg(1).current).det_sch_rc(i_det,2)),'FaceColor',[0.5451    0.4314    0.3333] );
        x=mtg(mtg(1).current).det_sch_coords(i_det,1)-.5;
        y=4*mtg(mtg(1).current).det_sch_coords(i_det,2)-1;
        text(x,y,mtg(mtg(1).current).det_name(i_det),'Color',[1 1 1],'fontsize',12);  % label the detector patch
    end
            %label the next hole over with the column number
            x=mtg(mtg(1).current).det_sch_coords(i_det,1)+.2; %1.3 on other side
            y=4*mtg(mtg(1).current).det_sch_coords(i_det,2)-.85;
            text(x,y,num2str(mtg(mtg(1).current).det_sch_rc(i_det,2)),'Color','k','fontsize',8);  % label the source row number
end

