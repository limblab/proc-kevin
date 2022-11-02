#! /usr/bin/python
#
# LSTM_utils
#
# A list of utilities for the LSTM exploration jupyter notebook, just to make 
# the notebook cleaner. Things will be shifted over here as I am sure that 
# they are working properly



# -------------------------------------
# import what we need

# start with the basics
import numpy as np
import pandas as pd
from scipy.io import loadmat
from matplotlib import pyplot as plt

# bring in everything for the linear models
from sklearn import linear_model
from sklearn.model_selection import train_test_split, KFold
from sklearn import metrics

# tf stuff
import tensorflow as tf
from tensorflow.keras.layers import Dense, Dropout, LSTM
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras.models import Sequential
from tensorflow.keras import backend as K


# -----------------------------------------------------------
# Define modules
# -----------------------------------------------------------

# load the data into pandas dataframes
#
# It looks like this will input a dictionary containing (among other things) numpy arrays for each of the datasets for the day. We'll pull in each of them, and parse accordingly.
#
# In the "binned" numpy arrays (two levels down), the organization seems to be:
#
# 0. timestamps
# 1. metadata
# 2. EMG names
# 3. EMG data
# 4. Force names
# 5. Force data
# 6. electrode and unit number
# 7. channel and unit number
# 8. Firing Rates (in hz)
# 9. Kin (cursor kin?) names
# 10. Kin (cursor kin?) data
# 11. Vel Data
# 12. Vel Names
# 13. Accel Data
# 14. Accel Names
# 15. Digital Words and timestamps
# 16. Targets:
#     0. corner locations and appearance time 
#     1. rotations and appearance time
# 17. Trial table data
# 18. Trial Table Labels
# 19. 
# 20. 
# 21. 
def load_josh_mat(curr_data, n_lags=10):
    # Load the data into pandas dataframes
    #
    # Outputs:
    #   timestamps 
    #   firing
    #   EMG
    #   force
    #   kin
    timestamps = curr_data[0][0][0].reshape(-1)
    # create a couple of pandas data frames -- this will make things a bit easier

    # EMG
    emg_names = [curr_data[0][0][2][ii][0][0] for ii in np.arange(len(curr_data[0][0][2]))]
    EMG = pd.DataFrame(curr_data[0][0][3], columns=emg_names, index=timestamps)

    # Forces
    force_names = [curr_data[0][0][4][ii][0][0] for ii in np.arange(len(curr_data[0][0][4]))]
    force = pd.DataFrame(curr_data[0][0][5], columns=force_names, index=timestamps)

    # Firing Rates
    channel_names = [f"cc{row[0]:03d}ee{row[1]}" for row in curr_data[0][0][7]]
    firing = pd.DataFrame(curr_data[0][0][8], columns=channel_names, index=timestamps)

    # Kin -- not sure if cursor or ang of wrist. Will need to check
    kin_names = curr_data[0][0][9]
    vel_names = curr_data[0][0][12]
    acc_names = curr_data[0][0][14]
    kin = pd.DataFrame(curr_data[0][0][10], columns=kin_names, index=timestamps)
    try:
        kin = kin.join(pd.DataFrame(curr_data[0][0][11], columns=vel_names, index=timestamps))
        kin = kin.join(pd.DataFrame(curr_data[0][0][13], columns=acc_names, index=timestamps))
    except:
        pass

    # trial table
    trial_names = curr_data[0][0][18]
    trial_table = pd.DataFrame(curr_data[0][0][17], columns=trial_names)

    return timestamps, firing, EMG, force, kin



# --------------------------------------------------------------------
# Reorganize the data for the LSTMs
# For firing rates: 
#   the lags in a second (intermediate) dimension
#   
# For the EMGs:
#   Add a one-hot labeling array for the task (size TxC, where C == # conditions)
#   And an array of 1/Var (size TxM, where C == # of muscles)
#

# start with helper functions, since then we can just do the same thing for both the train
# and test dataset

# neurons
def LSTM_preprocess_firing(firing:dict, N_lags):
    firing_sets = list(firing.keys())
    n_neurons = firing[firing_sets[0]].shape[1] # number of neurons
    firing_dict = {} # create the empty dictionary
    comb_firing = np.ndarray((0,N_lags,n_neurons)) # empty array for the combined set
    
    # for each condition
    for firing_name, firing_data in firing.items():
        temp_firing = np.ndarray((firing_data.shape[0], N_lags, n_neurons)) # create and empty array for the lags
        for ii in np.arange(N_lags): # shift through the lags
            temp_firing[:,ii,:] = firing_data.shift(-ii, fill_value = 0).to_numpy() # create the shifts, stick in d1
        firing_dict[firing_name] = temp_firing # put it into the dictionary
        comb_firing = np.append(comb_firing, temp_firing, axis=0) # and append it onto the combined list
    
    firing_dict['Combined'] = comb_firing # put it into the dictionary

    return firing_dict

# EMGs
def LSTM_preprocess_EMG(EMG:dict):

    cond_name = list(EMG.keys()) # list of training sets
    EMG_names = EMG[cond_name[0]].columns # EMG names 
    
    # EMGs
    out_dict = {} # dict of the EMGs
    comb_o = np.ndarray((0,len(EMG_names)))
    out_dict_oh = {} # dict of the oh array
    comb_oh = np.ndarray((0,len(cond_name))) # comb array of the EMG one-hot encoding
    comb_var = np.ndarray((0,len(EMG_names)))
    out_dict_var = {} # dict of the EMG variances
    
    # rip through each condition
    for ii_cond, cond in enumerate(EMG.keys()): # for each training condition
        out_dict[cond] = EMG[cond].to_numpy() # convert to numpy
        out_dict_var[cond] = np.tile(np.var(out_dict[cond], axis=0),(len(out_dict[cond]),1))
        
        # one-hot
        oh_temp = np.zeros((out_dict[cond].shape[0],len(cond_name)))  
        oh_temp[:,ii_cond] = 1 # set the appropriate column to 1
        out_dict_oh[cond] = oh_temp
        
        # append things
        comb_o = np.append(comb_o, out_dict[cond], axis=0) # append the combined array
        comb_oh = np.append(comb_oh, oh_temp, axis=0)
        comb_var = np.append(comb_var, out_dict_var[cond], axis=0)

    # populate the "Combined" dataset
    out_dict['Combined'] = comb_o 
    out_dict_oh['Combined'] = comb_oh
    out_dict_var['Combined'] = comb_var 

    return out_dict, out_dict_oh, out_dict_var

# wrapper around the firing and EMG management
def LSTM_preprocess(firing_train: dict, EMG_train: dict, firing_test: dict, EMG_test: dict, N_lags=10):
    # Arranges the firing data for each condition into an TxLxN np array,
    #       plus a concatenated array (C*T)xLxN
    #       Returns each as an item in a dictionary
    #
    # Creates a one-hot array and a 1/var array for each EMG set, then 
    #       returns each as a nested dictionary items along with the combined
    #       version of each
    
    # start with the training data
    train_firing_dict = LSTM_preprocess_firing(firing_train, N_lags=N_lags) # train dataset
    test_firing_dict = LSTM_preprocess_firing(firing_test, N_lags=N_lags) # test dataset

    # EMGs
    train_EMG_dict, train_oh_dict, train_var_dict = LSTM_preprocess_EMG(EMG_train)
    test_EMG_dict, test_oh_dict, test_var_dict = LSTM_preprocess_EMG(EMG_test)

    return train_firing_dict, train_EMG_dict, train_oh_dict, train_var_dict, test_firing_dict, test_EMG_dict, test_oh_dict, test_var_dict



# -------------------------------------------------------------------
# Plotting functions 
# -------------------------------------------------------------------

# VAF plotting
def plot_VAFs(train_VAFs: dict, test_VAFs: dict, muscles):    
    
    # Plotting VAFs -- comparing the training sets and testing sets
    fig_vaf, ax_vaf = plt.subplots(ncols = 2, constrained_layout=True)
    i_muscles = np.arange(len(muscles)) # indexing on the x axis
    n_train = len(train_VAFs)
    n_test = len(test_VAFs)
    train_width = (8//n_train)*.1 # the bars together should only take 80% of each muscle's width
    test_width = (8//n_test)*.1
    
    # training plot
    for train_ii, vaf in enumerate(train_VAFs.items()):
        ax_vaf[0].bar(i_muscles + train_width*train_ii, vaf[1], width=train_width, label=vaf[0])
    ax_vaf[0].set_xticks(i_muscles + .4)
    ax_vaf[0].set_xticklabels(muscles)
    ax_vaf[0].set_title('Training datasets')
    
    # test plot
    for test_ii, vaf in enumerate(test_VAFs.items()):                              
        ax_vaf[1].bar(i_muscles + test_width*test_ii, vaf[1], width = test_width, label=vaf[0])
    ax_vaf[1].set_xticks(i_muscles + .4)
    ax_vaf[1].set_xticklabels(muscles)
    ax_vaf[1].set_title('Testing Datasets')



    # For each bar in the chart, add a text label.
    for chart in ax_vaf:
        chart.set_ylim([-.05, 1.05])
        chart.set_xlabel('Muscle')
        chart.set_ylabel('R2 Score')

        chart.legend()

        for bar in chart.patches:
            # The text annotation for each bar should be its height.
            bar_value = bar.get_height()
            # Format the text with commas to separate thousands. You can do
            # any type of formatting here though.
            text = f'{bar_value:.02f}'
            # This will give the middle of each bar on the x-axis.
            text_x = bar.get_x() + bar.get_width() / 2
            # get_y() is where the bar starts so we add the height to it.
            text_y = np.max([bar.get_y() + bar_value, 0.01]) # keep it from going too far below zero, and disappearing
            # If we want the text to be the same color as the bar, we can
            # get the color like so:
            bar_color = bar.get_facecolor()
            # If you want a consistent color, you can just set it as a constant, e.g. #222222
            chart.text(text_x, text_y, text, ha='center', va='bottom', color=bar_color,
                    size=12)

        # turn off the spines
        for spine in ['right','top','bottom','left']:
            chart.spines[spine].set_visible(False)


# plot the recorded vs predicted values. Takes in dicts
# creates a figure for each condition
def plot_rec_pred(recording: dict, prediction: dict, muscle, VAFs: dict, title_append = ''):
    
    n_EMGs = len(muscle)
    n_rows = int(np.ceil(np.sqrt(n_EMGs)))
    n_cols = int(n_EMGs//n_rows)

    for cond in prediction.keys():
        fig, ax = plt.subplots(nrows=n_rows, ncols=n_cols, sharex=True, constrained_layout=True)

        for muscle_ii in np.arange(n_EMGs):
            row_i = int(muscle_ii//n_rows)
            col_i = int(muscle_ii%n_rows)
            ax[row_i,col_i].plot(recording[cond][:,muscle_ii], label='Recorded')
            ax[row_i,col_i].plot(prediction[cond][:,muscle_ii], label=f'VAF: {VAFs[cond][muscle_ii]:.03f}')
            ax[row_i,col_i].set_title(f"{muscle[muscle_ii]}")
            _ = ax[row_i,col_i].legend()

            # turn off the spines
            for spine in ['right','top','bottom','left']:
                ax[row_i,col_i].spines[spine].set_visible(False)

        fig.suptitle(f'Recordings from {cond} {title_append}')
