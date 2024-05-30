# FP-Data-Analysis
Code for analyzing fluorescence polarization data from a plate reader.

<p>This code is designed to take 3 excel sheets and output a graph showing triplicate data plotting polarization
against the base 10 logarithm of the concentration.</p>
<p>The script is designed to take 3 replicates, each scanned 3 times (idea is to cut down on random variation by getting multiple scans).</p>
<p>The script is set so the probe only control is in well B1 of a 96 well plate and the replicates are in columns 6, 7, 8 with the high concentration cold ligand conditions in row 1.</p>
<p>Specify the high concentration cold ligand and the dilution factor</p>
<p>The libraries needed for this script are tidyverse and readxl</p>
