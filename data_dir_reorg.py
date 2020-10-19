#! /usr/bin/python3.7
# -*- coding: utf-8 -*-
"""
data_dir_reorg(reorg_path='.')
Server Data directory reorganization

looks through the current directory for .nev, .nsx files, and
reogranizes everything into a Data/monkey/date directory structure.

Then, if the directory is empty it deletes everything
"""
import os
from datetime import date


# look along this path, look for these file extensions
def data_dir_reorg(reorg_path='.', 
                   exts = ('.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6'),
                   monkey = ('fish')):
    
    # walk through the current directory
    results = [[dp,f] for dp, dn, filenames in 
              os.walk(reorg_path) for f in filenames 
              if os.path.splitext(f)[1] in exts]

    dir_dates = list(set([portions for portions in fn[1].split('_') 
                          for fn in results
                          if (portions.isdigit() and len(portions) == 8)]))