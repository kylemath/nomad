## NOMAD ##

![alt text](gui/nomad.jpg)


# Near-infrared Optical Montage Automated Design

This is software to select locations on an optical imaging helmet for sources and detectors, to create montage maps for setup, and to assign source and detector order using a graph colouring approach.

nomad.m - v3.0 - Near-infrared Optode Montage Automated Designer 
Dr. Kyle Mathewson, University of Alberta - Sept 27, 2019 - modified to work on matlab 2019

nomad.m - v2.0 - Near-Near-infrared Optode Montage Automated Designer 
Dr. Kyle Mathewson, University of Illinois - Feb 7, 2013

nomad.m - v1.0 - Near-infrared Optode Montage Automated Designer 
Dr. Kyle Mathewson, University of Illinois - Nov 11, 2012

Formerly Montage_design_2012.m - Interactively design montages, place detectors, srcs, and assign mux numbers
Modified from earlier Montage_design.m by Kyle Mathewson & Ed Maclin
Based on Montage Design techniques from Kathy Low

Copyright Dr. Kyle Mathewson, University of Alberta

# Input 
uses standard .elp files of the CNL helmets - load from the settings

# Steps

1) calls helmet_schem_maker.m to make a schematic and scatterplot of the locations
2) Allows the user to choose detectors 
3) Manually select sources - Automatic works for patches
4) Calls assign_mux.m, or another algorithm to assign mux numbers 
5) Calls FinalSwap.m to move srcs to accomodate new mux numbers

# GUI Steps

1) Settings - Set up the montage itself, load your own .elp file or saved structure, number
of sources and detectors, and the mux number.

2) Design Montage - Identify the location of sources and detector
interactively

2) Assign Mux - This is a wrapper for the mux assignment alogrithms for
the user to interactivly try to assing mux numbers, and check their crosstalk

3) Output - This final GUI will let the user save the output files and
the data structure.


# Output, 
1) Schematic of src and det locations and mux's, save as .bmp
2) Scatterplot on scalp, histogram of distances, and some stats
3) Visualize the Graph
4) .mtg files for use by coreg and opt3d
5) Graph Definition Files for BOXY aquisition
6) Save the mtg structure for future use




# Updates

NOMAD - Version 2.0 - Feb 7, 2012

# General
Reorganized paths and subpaths, elp and examples files in subfolders
Increased resolution of background images and included EROS helmet

# Setting
Reorganized SettingsGUI, simplified, included instructions and tips
IMPORTANT - Custom .elp automatic S and D indentification from the .elp file, the first line of the .elp file must be the SSDDSSDDSS identity of each row
fixed load button bugs and moved it to more prominent position

# Montage and Schematic
* Created a GUI for the src/det selection, and built the old script into it
* IMPORTANT - Created buttons and instructions to automatically resize the src/det spacing
* IMPORTANT - Created a restart button to refresh the window and start over
* IMPORTANT - included step by step written instructions on the right
* Created a Done button to move forward to mux assignment
* back button to return to settings and make changes
* I HAVE NOT FIXED THE COLOUR PROBLEMS WITH SRC UNDO YET

# Mux Assignment
* Again I revamped the GUI, removed the background image for simplicity
* IMPORTANT - CROSSTALK CHECK - I added an additional check against crosstalk by pressing the orange button
* this brings up two new figures, the first of which shows the conflict matrix with white dots showning conflict and the second shows, for each mux number, the distance of each src with this mux number from each detector. Red lines show cross talk. Both show warnings when crosstalk is detected. 
* IMPORTANT - REMOVED SWAP - this seemed to be causing problems of crosstalk and was removed as an option organized it from top to bottom in a temporal order, and numbered added colour to the important buttons, and a reminder to color both mtgs


# TODO 
* Save some settings and load them?
* Change colouring during montage selection
* Fix undo for source placement, the other source of cross talk problems right now
* Create buttons to return to detector, right click detector during srcs?
* Space out detectors in bounding box
* Space out srcs in bounding box
* Add funcitonality for patches
* Update GDF creator with .dll from DENIS for correct BOXY file creation
* Display lines on surface of convex hull and shade the hull as such
* Better 2D projection of ELP file for schematic
* Create output for DENIS and BOXY to visualize signal quality
* Change shading of src holes 
* Made schematic background grey - JW 




# NOMAD - Version 1.02 - Nov11, 2012


# Nov 11 - 
* make Montage - Fix undo so it removes the white spaces and the gray areas
* Assign mux - Add functionality for dual mtgs - select which one
      -Make Initial settings match existing montage
* add the head plot and stats to Assign the mux
* 2 wavelength gdf files and distance file
* Create option to resume making montage for mux assign
* Create optoin to resume mux assign / from output
* changed the mtg1 and mtg2 settings to a array of structure mtg with mtg(1) and mtg(2)
* this allows for many mtgs to be combined
* loading old files is somewhat supported


# Nov 10 - Created the mux assignment GUI, Integrated the Setting and OutputGUI
* Included feature to load in saved mtg files
* separated the assign_the_mux from the make_the_montage
* fixed bug to save created colourings to the mtg1 and mtg2 structs


# Nov 6 - KEM
* renamed NOMAD
* Changed montage display to add dual wavelength 
* added dual wavelength .mtg files
* added monte carlo tries setting to menu
* added parallel monte carlo options to menu
* deleted many old colour approaches - should consolidate them
* need to make graph definition files and distance graph for dual wavelength- DONE


# Nov 5 - KEM
* Updated GUI to add dual fibre capabillity
* Created new name - NOMAD - and a logo for the GUI
* Moved the detector naming to the schematic maker - helmet_schem_maker
* added custom helmet capabililty - and location to add source detector order for this format
* made graph definition files  and distance diagram work for single oxyplex machine, and single montge
* made .mtg file work for single oxyplex and single montage - combined mtg file for single montage

# March 13 - KEM
*  Changed n_try to 10000 - more tries to colour before swapping
*  Changed trisurf alpha level to .5 instead of .9 - convex hull is more transparent

# March 14 - KEM
*  Added editor cells to increase readability of code

# March 15 - KEM
*  Added functionality for multiple mtg's per subject, indicate in Settings
* Moved the head plot and histogram after mtg loop and made a function to plot it over both session
*  Added the graph computation to speed mux assignment, put back DESATUR -build
*  Added Source Distance Function and Assignment type to advanced settings
*  Fixed bug when srcs were right click removed but the detectors were still counting them towards the total allowed
*  Fixed bug of the colours going out of range and crashing the program by setting a limit on lower and upper
*  Added saving of multiple mtg schematic, saving of all mtgs created

# March 22 - KEM 
*  Changed .mtg file output for 2 sessions 2 machines to combine all into 1
*  Added graph definition file functionality for 2 sessions 2 machines
*  Fixed many bugs

# Version 2012b #


# March 28 - KEM
*  Added setting for schematic colors, with options for CNL, DOIL or custom -
*  Added titles and labels to schematics
*  Additional output matrix page for each opt and session colored by distance

# March 29 - KEM
*  Reversed colors to match the bank orientation - JW suggestion 
*  Changed detectors to match each room, and the proper colours - JW



## TODO Future##
# KM 03/2012

*  Restrict channels less than the minimum distance - DONE
*  Precompute all distances in helm file and look up throughout the code -DONE
*  Include feature to load your own .elp file - DONE
*  debug DESATUR,include Greedy - DONE
*  Change assign_mux to use the graph instead to speed up - DONE, slower
*  Fix src and det assignment when mouse miss the schematic


 
