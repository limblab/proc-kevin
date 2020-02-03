# 30k vs nev comparison 
#
# implemented in the neuroexplorer python script system
# blackrock's python .nev and .nsx readers are super slow, and
# the .nsx files crash the GOBs when opened in Matlab. 
#
# So... here we are. trying it out here.


import nex, matplotlib, os
import numpy as npy

# read the documents we want
nsxFID = nex.OpenDocument('C:\Users\klb807\Documents\Data\30kvNev\20190909_Pop_horiz_wm_001.ns6')
nevFID = nex.OpenDocument('C:\Users\klb807\Documents\Data\30kvNev\20190909_Pop_horiz_wm_001.nev')



