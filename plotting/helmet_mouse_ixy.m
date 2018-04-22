% helmet_mouse_ixy.m - return "patch index" from mouse click on schematic
% assumes current figure is the helmet schematic defined by "helm"

function [jx jy but]=helmet_mouse_ixy

global helm

dx=helm.dx;
dy=helm.dy;

[x,y,but,ax]=ginputax(1);    % get mouse click coords

% convert mouse "x" to schematic row number
%

for jx=1:helm.n_rows    % scan rows
    ix=helm.sch_coords{jx}(1,1);    % get xcoord of this row
    if (dx*(ix-1)<=x) && (x<=dx*ix);break;end % done if x is in patch<x>
end

% convert mouse "y" to hole number
%
for jy=1:length(helm.sch_coords{jx})
    iy=helm.sch_coords{jx}(2,jy);
    if (helm.sdy(jx)*dy*(iy-1)<=y) && (y<=helm.sdy(jx)*dy*iy);break;end
end

%If they click on the scatter get the item - Move into Helmet_mouse_ixy
if ax == helm.plot_handle(1)  
    for i_loc = 1:helm.n_locs
        if (x <= helm.sensor_xy(i_loc,1) + 2) && (x >= helm.sensor_xy(i_loc,1) - 2) && (y <= helm.sensor_xy(i_loc,2) + 2) && (y >= helm.sensor_xy(i_loc,2) - 2)
            for i_row = 1:helm.n_rows
                temp = find(helm.sensor_i{i_row} == i_loc);
                if ~isempty(temp)
                    jx = i_row;
                    jy = temp;
                end
            end
        end
    end
end

