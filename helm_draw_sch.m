% helm_draw_sch.m - 
% draw a schematic helmet from a "helm" structure
% returns figure handle and hancles of each "patch"
% Updated March 3, 2012 by Kyle Mathewson, Beckman Institute
% to include the scatter plot of the surface projected 3d elp points

function [ph plot_i plot_handle]=helm_draw_sch

global helm

dx=helm.dx;
dy=helm.dy;

% draw the schematic

% scrsz = get(0,'ScreenSize');
% fig1=figure('Position',[1 1 scrsz(3)/1.1 scrsz(4)/1.1],'Color','w');
plot_handle = subplot(1,2,1);
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
subplot(1,2,2);
    helm.spot = 100;
    scatter(helm.sensor_xy(:,1),helm.sensor_xy(:,2),helm.spot,helm.sensor_clr,'filled'); 
    axis off; 
    hold on; 


plot_i = get(plot_handle,'parent');
plot_handle = get(plot_i,'child'); %returns an array of subplot handles