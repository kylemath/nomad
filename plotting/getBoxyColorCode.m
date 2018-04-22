function colorCode=getBoxyColorCode(color)

if(strcmp(color,'Black'))
    colorCode=0;
elseif(strcmp(color,'Blue'))
    colorCode=1;
elseif(strcmp(color,'Green'))
    colorCode=2;
elseif(strcmp(color,'Cyan'))
    colorCode=3;
elseif(strcmp(color,'Red'))
    colorCode=4;
elseif(strcmp(color,'Magenta'))
    colorCode=5;
elseif(strcmp(color,'Brown'))
    colorCode=6;
elseif(strcmp(color,'Light Gray'))
    colorCode=7;
elseif(strcmp(color,'Gray'))
    colorCode=8;
elseif(strcmp(color,'Light Blue'))
    colorCode=9;
elseif(strcmp(color,'Light Green'))
    colorCode=10;
elseif(strcmp(color,'Light Cyan'))
    colorCode=11;
elseif(strcmp(color,'Light Red'))
    colorCode=12;
elseif(strcmp(color,'Light Magenta'))
    colorCode=13;
elseif(strcmp(color,'Yellow'))
    colorCode=14;
elseif(strcmp(color,'White'))
    colorCode=15;
elseif(strcmp(color,'Pale Blue'))
    colorCode=16;
elseif(strcmp(color,'Pale Green'))
    colorCode=17;
elseif(strcmp(color,'Medium Gray'))
    colorCode=18;
else
    colorCode=-1;
end
