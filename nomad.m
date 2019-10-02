%% nomad.m - v3.0 - Near-Near-infrared Optode Montage Automated Designer 
% Dr. Kyle Mathewson, University of Illinois - May 24, 2013

% see README.md for latest info

%% Steps

% 1) calls helmet_schem_maker.m to make a schematic and scatterplot of the locations
% 2) Allows the user to choose detectors 
% 3) Manually select sources - Automatic works for patches
% 4) Calls assign_mux.m, or another algorithm to assign mux numbers 
% 5) Calls FinalSwap.m to move srcs to accomodate new mux numbers

%% GUI Steps

% 1) Settings - Set up the montage itself, load your own .elp file or saved structure, number
% of sources and detectors, and the mux number.

% 2) Design Montage - Identify the location of sources and detector
% interactively

% 2) Assign Mux - This is a wrapper for the mux assignment alogrithms for
% the user to interactivly try to assing mux numbers, and check their crosstalk

% 3) Output - This final GUI will let the user save the output files and
% the data structure.


%% - Output, 
% 1) Schematic of src and det locations and mux's, save as .bmp
% 2) Scatterplot on scalp, histogram of distances, and some stats
% 3) Visualize the Graph
% 4) .mtg files for use by coreg and opt3d
% 5) Graph Definition Files for BOXY aquisition
% 6) Save the mtg structure for future use


%-------------------
%% Set up workspace
%-------------------

clear all
close all
clc
addpath(genpath('utils'));
addpath(genpath('elp'));
addpath(genpath('examples'));
addpath(genpath('gui'));



global mtg helm


%% Run the GUI and make the helm structure
gui_fig = SettingGUI; %Run the GUI to get the settings info
waitfor(gui_fig);






