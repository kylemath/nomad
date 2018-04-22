function GDFTextFileGenerator_KM(dist,montage_name,saveDir,i_mtg)

global mtg

% Adapted again by Kyle on April 28, 2013 - Now creates .gds files that
% override the .gdf files used by boxy. It takes blank .gdf templates,
% renames them, and then creates the 4 .gds.# text files to specify the
% graph data and colours
%


% Adapted by Kyle Mathewson from the code below for inclusion into Montage
% Design as a function - 3/20/12 - load in a dist file and a montage name,
% and the save directory


%**************************************************************************
%GDF Text File Generator
%
%Takes a montage and elp file and creates graph definition text files for
%every detector that can be loaded into BOXY.
%
%Output files are in form:
%'Det[detector letter]_[machine name]_[graph type].txt'
%
%Can also create a tab delimited distance file.
%
%@author John Walker
%@version 1.0.0
%@date 3/18/12
%
%For version notes see bottom of code.
%**************************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Variables to be Defined by User%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_distIntervals=5;%Number of intervals with a special color in the graph (does not include the interval for all undetectable sources) Needs to be 1 or more but max is 5 (can be modified to accept 6 or more)
minDist=mtg(i_mtg).min_dist;%Minimum distance that you should care about.  If unsure see montage generator for your specified minimum distance
maxDist=mtg(i_mtg).max_dist;

limits = linspace(0,maxDist,n_distIntervals+1);  %equally space the intervals from 0 to the max

%Definitions for each interval.  The minimum interval is anything larger
%than the previous interval's max.  Please put them in order such that
%interval 1 contains smaller distances than interval2.  In otherwords you
%must always make it so that int1_maxDist<int2_maxDist<int3_maxDist. If
%n_distIntervals is < 5 then only the number of specified intervals will be
%used.

%interval 1 is defined as >=minDist and <=int1_maxDist
int1_maxDist=minDist;%max distance for interval 1
int1_Color='Black';%color that will be shown in the graphs in BOXY for interval 1 (See below for possible colors)

%interval 2 is defined as >int1_maxDist and <=int2_maxDist
int2_maxDist=25;%max distance for interval 2
int2_Color='Red';%color that will be shown in the graphs in BOXY for interval 2 (See below for possible colors)

%interval 3 is defined as >int2_maxDist and <=int3_maxDist
int3_maxDist=38;%max distance for interval 3
int3_Color='Blue';%color that will be shown in the graphs in BOXY for interval 3 (See below for possible colors)

%interval 4 is defined as >int3_maxDist and <=int4_maxDist
int4_maxDist=49;%max distance for interval 4
int4_Color='Light Blue';%color that will be shown in the graphs in BOXY for interval 4 (See below for possible colors)

%interval 5 is defined as >int4_maxDist and <=int5_maxDist
int5_maxDist=60;%max distance for interval 5
int5_Color='Pale Blue';%color that will be shown in the graphs in BOXY for interval 5 (See below for possible colors)


undetect_Color='Light Gray';%The color for all distanes that fall outside of the intervals above

%Possible Colors (copy and paste into the fields above):
% Black
% Blue
% Cyan
% Green
% Brown
% Yellow
% Red
% Magenta
% Light Blue
% Light Cyan
% Light Green
% Light Red
% Light Magenta
% Gray
% Medium Gray
% Light Gray
% Pale Blue
% Pale Green
% White




n_det=size(dist,1);%number of detectors present in the distance matrix
n_mux=size(dist,2);%number of mux channels present in the distance matrix
colors= cell(n_det,n_mux);%initializes cell array of colors for every detector x mux channel combo
colorCodes=zeros(n_det,n_mux);%initializes matrix of color codes for every detector x mux channel combo


%%%%%%%%%%%%%%%
%Assign Colors%
%%%%%%%%%%%%%%%

intColorCodes=zeros(n_distIntervals+1,1);%initialize array of color codes for each interval
%Get color codes for each chosen interval
for i=1:n_distIntervals
    intColorCodes(i)=getBoxyColorCode(eval(['int' num2str(i) '_Color']));
    
end
intColorCodes(n_distIntervals+1)=getBoxyColorCode(undetect_Color);%gets the color codes for the undetectable range

%Get max distance from the interval containing the greatest distances
max_dist=eval(['int' num2str(n_distIntervals) '_maxDist']);

%assign colors and color codes for every det x mux channel 
for d=1:n_det
    for m=1:n_mux
        s_dist=dist(d,m);
            if(s_dist>= 0 && s_dist<int1_maxDist)%if the distance is in the first interval
                colors{d,m}=int1_Color;
                colorCodes(d,m)=intColorCodes(1); 
                
            elseif(s_dist>=int1_maxDist&&s_dist<int2_maxDist)%if the distance is in the second interval
                colors{d,m}=int2_Color;
                colorCodes(d,m)=intColorCodes(2);
                
            elseif(s_dist>=int2_maxDist&&s_dist<int3_maxDist)%if the distance is in the third interval
                colors{d,m}=int3_Color;
                colorCodes(d,m)=intColorCodes(3);
                
            elseif(s_dist>=int3_maxDist&&s_dist<int4_maxDist)%if the distance is in the third interval
                colors{d,m}=int4_Color;
                colorCodes(d,m)=intColorCodes(4);
                
            elseif(s_dist>=int4_maxDist&&s_dist<int5_maxDist)%if the distance is in the third interval
                colors{d,m}=int5_Color;
                colorCodes(d,m)=intColorCodes(5);
        
            else %if the distance is less than the min or greater than the max of the interval containing the largest numbers then it is labeled as undetectable
                colors{d,m}=undetect_Color;
                colorCodes(d,m)=intColorCodes(size(intColorCodes,1));
            end
        
        
    end
end

%%%%%%%%%%%%%%%%%%%%%
%Create & Save Files%
%%%%%%%%%%%%%%%%%%%%%

detLetters=char(65:65+n_det); %Get the letters from A to number of detectors to use % KM removed the function and did it here


groups = {'A-D';'E-H';'I-L';'M-P'};

%Goes through and creates the text files for AC, DC, and Phase for each
%detector
for d=1:n_det
    
    group_mem = mod(d-1,4)+1;
    
 
    group = ceil(d/4);
    
    %Creates file names for every detector
    path = [saveDir 'AC' filesep];
    if ~exist(path)
        mkdir(path)
    end
    ACFileName=[saveDir 'AC' filesep montage_name '_Det' groups{group} '_AC.gds.' num2str(group_mem)];
    if group_mem == 1     
        copyfile('output/gdf_template.gdf', [saveDir 'AC' filesep montage_name '_Det' groups{group} '_AC.gdf'])
    end
    
    path = [saveDir 'DC' filesep];
    if ~exist(path)
        mkdir(path)
    end
    DCFileName=[saveDir 'DC' filesep montage_name '_Det' groups{group} '_DC.gds.' num2str(group_mem)];
    if group_mem == 1     
        copyfile('output/gdf_template.gdf', [saveDir 'DC' filesep montage_name '_Det' groups{group} '_DC.gdf'])
    end
    path = [saveDir 'Ph' filesep];
    if ~exist(path)
        mkdir(path)
    end
    PhFileName=[saveDir 'Ph' filesep montage_name '_Det' groups{group} '_Ph.gds.' num2str(group_mem)];
        if group_mem == 1     
        copyfile('output/gdf_template.gdf', [saveDir 'Ph' filesep montage_name '_Det' groups{group} '_Ph.gdf'])
    end
    
    %Creates and opens the files- will delete anything in the files if
    %alreay created
    fidAC=fopen(ACFileName,'w');
    fidDC=fopen(DCFileName,'w');
    fidPh=fopen(PhFileName,'w');
    
    
    fprintf(fidAC, ['#Graph Title=Det ' detLetters(d) '\r\n#Left Y Axis Title=AC\r\n#X Axis Title=Mux\r\n#Tab Title=' montage_name ' AC ' groups{group} '\r\n#Left Y Axis Max=8000\r\n#Left Y Axis Min=0\r\n#Number Series=16\r\n']);
    fprintf(fidDC, ['#Graph Title=Det ' detLetters(d) '\r\n#Left Y Axis Title=DC\r\n#X Axis Title=Mux\r\n#Tab Title=' montage_name ' DC ' groups{group} '\r\n#Left Y Axis Max=200\r\n#Left Y Axis Min=0\r\n#Number Series=16\r\n']);
    fprintf(fidPh, ['#Graph Title=Det ' detLetters(d) '\r\n#Left Y Axis Title=StdDev(Ph)\r\n#X Axis Title=Mux\r\n#Tab Title=' montage_name ' Ph ' groups{group} '\r\n#Left Y Axis Max=20\r\n#Left Y Axis Min=0\r\n#Number Series=16\r\n']);
    
    %Prints standard header for each files
    fprintf(fidAC, '#\tData Source\tLabel\tColor Index\r\n');
    fprintf(fidDC, '#\tData Source\tLabel\tColor Index\r\n');
    fprintf(fidPh, '#\tData Source\tLabel\tColor Index\r\n');
    
    %For every mux channel print it's information into the file
    for m=1:n_mux
        for i_wvl = 1:mtg(i_mtg).n_wvls
            m2 = (mtg(i_mtg).n_wvls*m)+(i_wvl-mtg(i_mtg).n_wvls);
            fprintf(fidAC,'%d\tAC-%c,%d\t%d\t%d\r\n',m2, detLetters(d),m2,m2,colorCodes(d,m));
            fprintf(fidDC,'%d\tDC-%c,%d\t%d\t%d\r\n',m2, detLetters(d),m2,m2,colorCodes(d,m));
            fprintf(fidPh,'%d\tStdDev(Phase)-%c,%d\t%d\t%d\r\n',m2, detLetters(d),m2,m2,colorCodes(d,m));
        end
        
    end
    
    %Close the files so the next set of files can be created for the next
    %detector
    fclose(fidAC);
    fclose(fidDC);
    fclose(fidPh);
end

mtg(i_mtg).colorCodes = colorCodes;


fprintf('\nDone\n');
clear;




%**************************************************************************
%Version Notes
%
%@version 0.1.0 (2/18/12)
%   Code Completed and tested
%
%@version 0.2.0 (2/22/12)
%   Now accepts montage files and creates the distance files
%
%@version 1.0.0 (3/18/12)
%   Comments added and number of intervals expanded from 3 to 5 
%
%**************************************************************************