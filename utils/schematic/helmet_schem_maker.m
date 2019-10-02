function helmet_schem_maker

% from the following file turned automated and into a function by
% Kyle Mathewson - March 3, 2012 - Beckman Institute
% Montage_design.m now calls this with a helmet size and type, and it
% returns the schematic helm for use by montage_design_m

% helmet1.m - generates a "heml" stucture defining the layout of a
% particular helmet, based on Kathy's schematic layout
%
% "helm" comprises:
%   helm.n_rows - the number of rows on this helmet
%   helm.row_lables - an array of row labels
%   helm.sch_coords - a cell array of n_rows 2D (x/y by # of holes) matrices
%       of coordinates for drawing Kathy's schematic; defined below
%   helm.xyz - a cell array of 2D (xyz by # of holes) of actual coords from
%       .elp file
%   helm.colors - cell array of colors for each patch in the schematic
%   helm.hndl - cell array of each patch's handle



global mtg helm


helmet_type = 'motor';

switch mtg(1).helmet_type
    case {'Custom'}
        helmet = mtg(1).elp_file(1:end-4);
        helmet_type = 'custom';     % calling the custom order of rows
        % set these rows in helmet_schem_maker
        
    case{'APPLAB_GreenPilot'}
        helmet = 'APPLAB_greenpilot';
        helmet_type = 'applabpilot';

    case {'Max'}
        helmet = 'doil_max_ave';
        helmet_type = 'foam+';    
    case {'Norm+'}
        helmet = 'doil_norm_above_58_ave';
        helmet_type = 'foam';    
    case {'Norm-'}
        helmet = 'doil_norm_below_58_ave';
        helmet_type = 'foam';    
    case {'Mini'}
        helmet = 'doil_mini_ave';
        helmet_type = 'foam';    
        
    case {'Kens Patch'}
        helmet = 'patch-NewSequence';
        helmet_type = 'patch';     % calling the custom order of rows

    case {'Small'}
        helmet = 'small_mean';
    case {'Old Medium'}
        helmet = 'old_medium_mean';
    case {'New Medium'}
        helmet = 'new_medium_mean';
    case {'White Large'}
        helmet = 'large_white_mean';
    case {'Black Large'}
        helmet = 'large_black_mean';
end


%% read a .elp file and stash coords in "elp."
%
elp_name = [helmet '.elp'];
fid=fopen(elp_name);

if strcmp(helmet_type, 'motor') == 1
    helm.type='SDDSSDDSSDDSSDDSSDDSSDDS';  %for CNL motorcycle helmets
elseif strcmp(helmet_type, 'patch') == 1
    helm.type='SSSDDSSSDDSSSSSSDDSSSDDSSS'; 
elseif strcmp(helmet_type, 'foam') == 1
    helm.type='SSDSSDDSSDDSSDDSSDDSSDSS';
elseif strcmp(helmet_type, 'foam+') == 1
    helm.type='DSSDDSSDDSSDDSSDDSSDDSSDDSSD';
elseif strcmp(helmet_type, 'applabpilot') == 1
    helm.type='SSDDSSDDSSDDSSDDSSDDSSDDSS';
end


if strcmp(helmet_type,'custom') == 1
    a_line = fgets(fid);
    stuff = strread(a_line,'%s');
    helm.type = stuff{:};
end


a_line='a b'; %populate stuff for the first loop
stuff=strread(a_line,'%s');


%% Get  xyz coords for each fiducial location
%
while (strncmp(stuff(1),'%F',2)~=1)
    a_line=fgets(fid);
    stuff=strread(a_line,'%s');
end

helm.Nasion=1000*[str2num(char(stuff(2))) str2num(char(stuff(3))) str2num(char(stuff(4)))];
a_line=fgets(fid);
stuff=strread(a_line,'%s');
helm.LPA=1000*[str2num(char(stuff(2))) str2num(char(stuff(3))) str2num(char(stuff(4)))];
a_line=fgets(fid);
stuff=strread(a_line,'%s');
helm.RPA=1000*[str2num(char(stuff(2))) str2num(char(stuff(3))) str2num(char(stuff(4)))];




%% Get labels (src & det) and xyz coords for each location
%
i_loc=1;
while a_line ~= -1

    % Find lines starting with '%N'
    %
    while (strncmp(stuff(1),'%N',2)~=1)
        a_line=fgets(fid);
        if a_line == -1
            break
        end
        stuff=strread(a_line,'%s');
    end

    if a_line ~= -1 % if == -1, we're done
        if strcmp(char(stuff(2)),'Name') % Skip 1st '%N' line
            a_line=fgets(fid);
            stuff=strread(a_line,'%s');
        
  
        else    % Stash label and coordinates
            helm.sensor(i_loc)=stuff(2)';
            %fprintf('%s\n',char(sensor(i_loc)))
            a_line=fgets(fid);
            stuff=strread(a_line,'%s');
            if length(stuff) == 3 %If there is no %F before coordinates
                helm.sensor_xyz(i_loc,:)=1000*sscanf(a_line,'%g')';    % Convert meters to mm.
            else
                helm.sensor_xyz(i_loc,:)=1000*sscanf(a_line(4:end),'%g')';    % Convert meters to mm.
            end
            i_loc=i_loc+1;
        end % if 'Name'
    end % if a_line ~= -1
end % while a_line ~= -1
n_locs=i_loc-1;
helm.n_locs = n_locs;

%%%%%%%%%%%%%%%%%%%%%

%% Count the number in each row and the number of rows
first_loc = cell2mat(helm.sensor(1));
current_loc = first_loc;
first_row = first_loc(1:2);
prev_row = first_row;
helm.labels = first_row;
i_row = 1;

for i_loc = 1:n_locs
    prev_loc = current_loc;
    current_loc = cell2mat(helm.sensor(i_loc));
    current_row = current_loc(1:2);
    if strcmp(current_row,prev_row) ~= 1
        helm.loc_per_row(i_row) = str2num(prev_loc(3:4));
        helm.labels = vertcat(helm.labels,current_row);
        i_row = i_row+1;
        prev_row = current_row;
    end
    if i_loc == n_locs
        helm.loc_per_row(i_row) = str2num(current_loc(3:4));
    end
end
        
%assign these values to helm    
helm.n_rows=i_row;
helm.labels= [helm.labels(end/2:-1:1,:); helm.labels(end/2+1:end,:)];   %convert to left to right order
helm.loc_per_row = [helm.loc_per_row(end/2:-1:1) helm.loc_per_row(end/2+1:end)];


helm.spot = 100;
dx=1;dy=2;  % size of each patch
helm.dx=dx;
helm.dy=dy;
helm.src_clr=[.99 .99 .99];
helm.det_clr=[.4 .4 .4];   % default patch colors for schematic



%% Make Schematic
%This is to replace the by hand drawing of the box locations, estimate the
%spacing needed and the vertical position of the row.



for i_row = 1:helm.n_rows
    if strcmp(helm.type(i_row),'S') == 1   %if detector or source row
        helm.sdy(i_row) = 1;
        
        if strcmp(helmet_type, 'custom') == 1
            
            spacing = ceil(helm.src_space/helm.loc_per_row(i_row));  %how far apart the boxes are based on how many per row
        else
            spacing = ceil(helm.src_space/helm.loc_per_row(i_row));  %how far apart the boxes are based on how many per row
        end
    else
        helm.sdy(i_row) = 2;
        spacing = ceil(helm.det_space/helm.loc_per_row(i_row));
    end
    
    %This assigns the coordinates of each box
    row_start = (helm.loc_per_row(i_row)*helm.dy*spacing)/4;
    for i_pos=1:helm.loc_per_row(i_row)
        helm.sch_coords{i_row}(2,i_pos) = row_start-((i_pos-1)*spacing);
    end
    
    helm.sch_coords{i_row}(1,:)=   -1*(helm.n_rows/2)+i_row;  % THe horizontal position of the row with 0 the center of the screen
end


%---------
%% projection of the 3D elp coordinates onto a 2d plane and colour
%---------

%Recolour the rows based on their order

helm.sensor_clr = [];
src_count = 0;
det_count = 0;
for i_row = [helm.n_rows/2:-1:1 helm.n_rows/2+1:helm.n_rows]
    
    if helm.sdy(i_row) == 1
        src_count = src_count+1;
        helm.sensor_clr = [helm.sensor_clr; repmat([.8+(mod(src_count,2)*.2) .4+(mod(src_count,2)*.2) .4+(mod(src_count,2)*.2)],helm.loc_per_row(i_row),1)];
    elseif helm.sdy(i_row) == 2
        det_count = det_count+1;
        helm.sensor_clr = [helm.sensor_clr; repmat([.4+(mod(det_count,2)*.2) .4+(mod(det_count,2)*.2) .8+(mod(det_count,2)*.2)],helm.loc_per_row(i_row),1)];
    end
end

%find individual distances between each location and each other location for later
helm.all_dist = zeros(helm.n_locs);
for i_src1 = 1:helm.n_locs
    for i_src2 = 1:helm.n_locs
        helm.all_dist(i_src1,i_src2) = sqrt(sum((helm.sensor_xyz(i_src1,:)-helm.sensor_xyz(i_src2,:)).^2));
    end
end

%Transform by adding a fraction of the z dim to both the x and y dims
% helm.sensor_xy = mdscale(helm.all_dist,2);
% helm.sensor_xy = [helm.sensor_xy(:,2),helm.sensor_xy(:,1)];
helm.sensor_xy = helm.sensor_xyz(:,1:2);
helm.sensor_xy(:,1) =-1.* (helm.sensor_xyz(:,2).*(250-helm.sensor_xyz(:,3))/250);  %Flip them sideways and inverted to match
helm.sensor_xy(:,2) =(helm.sensor_xyz(:,1).*(200-helm.sensor_xyz(:,3))/200);
helm.scalp = convhulln(helm.sensor_xyz);


% find matching labels and stash coords in helm.xyz
%
for ix=1:helm.n_rows
    for iy=1:length(helm.sch_coords{ix})
        label=sprintf('%s%02.0f',helm.labels(ix,:),iy);
%         fprintf('ix=%2.0f, iy=%2.0f, label=%s\n',ix,iy,label)
        for il=1:length(helm.sensor)
            if label==char(helm.sensor(il))
                helm.xyz{ix}(iy,:)=helm.sensor_xyz(il,:);
                helm.xy{ix}(iy,:)=helm.sensor_xy(il,:);
                helm.sca_clr{ix}(iy,:)=helm.sensor_clr(il,:);
                helm.sensor_i{ix}(iy,:) = il;
            end
        end
    end
end


                
