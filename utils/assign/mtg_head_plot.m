function mtg_head_plot
%plot the convex hull, the connections of channels, and a histogram of
%distances and some stats

global helm mtg

%---------------------
% plot Srcs and Dets on head model, Good Channels, and Stats
%---------------------


% scrsz = get(0,'ScreenSize');
% fig1=figure('Position',[1 1 scrsz(3)/1.1 scrsz(4)/1.1],'Color','w');

for i_mtg = 1:mtg(1).n_mtgs

    %choose one of the mtg to analyze at a time

        trisurf(helm.scalp,helm.sensor_xyz(:,1),helm.sensor_xyz(:,2),helm.sensor_xyz(:,3),0,'facealpha',.2); axis off; hold on; %shading interp;                    

        for i_src = 1:size(mtg(i_mtg).src_xyz,1)
            for i_det = 1:size(mtg(i_mtg).det_xyz,1)
                    l(1,1)=mtg(i_mtg).src_xyz(i_src,1);
                    m(1,1)=mtg(i_mtg).src_xyz(i_src,2);
                    o(1,1)=mtg(i_mtg).src_xyz(i_src,3);
                    l(2,1)=mtg(i_mtg).det_xyz(i_det,1);
                    m(2,1)=mtg(i_mtg).det_xyz(i_det,2);
                    o(2,1)=mtg(i_mtg).det_xyz(i_det,3);
                if mtg(i_mtg).src_dist(i_det,i_src) <= mtg(i_mtg).max_dist
                    plot3(l,m,o,'color',[(mtg(i_mtg).src_dist(i_det,i_src)/mtg(i_mtg).max_dist) 0 0],'LineWidth',15);      
                end
            end
        end
        scatter3(mtg(i_mtg).src_xyz(:,1),mtg(i_mtg).src_xyz(:,2),mtg(i_mtg).src_xyz(:,3),'r','filled'); hold on;
        scatter3(mtg(i_mtg).det_xyz(:,1),mtg(i_mtg).det_xyz(:,2),mtg(i_mtg).det_xyz(:,3),'k','filled')

end

