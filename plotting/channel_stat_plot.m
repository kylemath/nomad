function channel_stat_plot
%plot the convex hull, the connections of channels, and a histogram of
%distances and some stats

global helm mtg

%---------------------
% plot Srcs and Dets on head model, Good Channels, and Stats
%---------------------


% scrsz = get(0,'ScreenSize');
% fig1=figure('Position',[1 1 scrsz(3)/1.1 scrsz(4)/1.1],'Color','w');
temp_dist = [];

for i_mtg = 1:mtg(1).n_mtgs
    
        mtg(i_mtg).proportion = length(find(mtg(i_mtg).src_dist<=mtg(i_mtg).max_dist))/(mtg(i_mtg).n_dets*mtg(i_mtg).n_muxs);
        temp_dist = [temp_dist; mtg(i_mtg).src_dist(mtg(i_mtg).src_dist<=mtg(i_mtg).max_dist)];

end


hist(temp_dist,40);      % plot a histogram of all good src/det distances 
title(['Total Channels = ' num2str(mtg(i_mtg).n_dets) ' dets * ' num2str(mtg(i_mtg).n_muxs*mtg(i_mtg).n_wvls) ' muxs * ' num2str(mtg(i_mtg).n_mtgs) ' mtgs = ' num2str(mtg(i_mtg).n_dets*mtg(i_mtg).n_muxs*mtg(i_mtg).n_mtgs) ', ' num2str(length(temp_dist)) ' Good, ' num2str(round((length(temp_dist)/(mtg(i_mtg).n_dets*mtg(i_mtg).n_muxs*mtg(i_mtg).n_mtgs))*100)) '%']);
