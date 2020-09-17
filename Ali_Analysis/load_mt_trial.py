# -*- coding: utf-8 -*-
"""
load_mt_trial.py

Code from Ali to split the trials for the analysis that we're doing

This needs to have xds and all supporting dependencies in place

"""
# import argparse

# parser = argparse.ArgumentParser()
# parser.add_argument('MT_path', type=str, nargs=1)
# parser.add_argument('MT_tasks', type=str, default='WM')
# parser.add_argument('bin_size', type=int, default = .05)
# parser.add_argument('MT_muscles', type=list)
import os
import xds
import numpy as np



def load_mt_trial(MT_path, MT_tasks, bin_size, MT_muscles, smoothing=True):
    filenames = os.listdir(MT_path)
    D = {}
    trial = {}
    seq_len = []
    for task in MT_tasks:
        data_file = [f for f in filenames if task in f]
        assert len(data_file) == 1
        data = xds.lab_data(MT_path,data_file[0])
        if bin_size!=0.001:
            data.update_bin_data(bin_size)
        spike = data.get_trials_data_spike_counts('R','gocue_time',0)
        emg = data.get_trials_data_EMG('R','gocue_time',0)
        trial_len = []
        for each in spike:
            trial_len.append(len(each))
        upper_lim = np.mean(trial_len)+3*np.std(trial_len)
        bad_trial_idx = np.argwhere(trial_len>upper_lim)
        longest_trial = max(np.delete(trial_len, bad_trial_idx))
        s = np.zeros([len(trial_len),longest_trial,np.shape(spike[0])[1]])
        e = np.zeros([len(trial_len),longest_trial,np.shape(emg[0])[1]])
        for i in range(len(trial_len)):
            if i not in bad_trial_idx:
                s[i,:trial_len[i]] = spike[i]
                e[i,:trial_len[i]] = emg[i]
        s = np.delete(s,bad_trial_idx,axis=0)
        e = np.delete(e,bad_trial_idx,axis=0)
        emg_names = data.EMG_names
        mlist = [emg_names.index(m) for m in MT_muscles]
        assert len(MT_muscles) == len(mlist),'Data does not include all the required muscles!'
        e = e[:,:,mlist]
        cap = np.mean(e.reshape(-1,len(mlist)),axis=0)+4*np.std(e.reshape(-1,len(mlist)),axis=0)
        e = e.clip(max=cap,min=0)
        if len(bad_trial_idx)>0:
            print(str(len(bad_trial_idx))+' trials out of '+str(len(trial_len))+' trials are removed as outliers')
        D[task[:-1]]=(s,e)
        seq_len.append(longest_trial)
        trial[task[:-1]] = np.asarray( data.get_one_colum_in_trial_info_table('tgtCorners'))
    return D,trial,np.shape(s)[2],seq_len
