# converter_gui.py
#
# Converts .tiff files to either mp4 or avi using ffmpeg
# on the backend. Basic GUI allows the user to select the
# import and save folder.
#
# KLB April 2023
# import things
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog as fd
import os


class converter_gui(tk.Frame):
    def __init__(self,parent):
        super().__init__(parent)

        # select directory for individual tiffs
        self.tiff_dn = tk.StringVar() # name of the input directory
        self.tiff_button = ttk.Button(self, text='Select Input Directory', command=self.get_dir)
        self.tiff_button.grid(row=0, column=0, padx=5, pady=5)

        # # select save filename
        # self.save_fn = tk.StringVar()
        # self.save_entry = ttk.Entry(self, textvariable=self.save_fn)
        # self.save_entry.grid(row=1, column=0, padx=5, pady=5)

        # convert button
        self.convert_button = ttk.Button(self, text='Convert Files', command=self.convert_files)
        self.convert_button.grid(row=2, column=0)

        # get it to run
        self.grid(row=0, column=0)


    # define convert command
    def convert_files(self):
        # check if the input directory exists
        if not os.path.exists(self.tiff_dn.get()):
            print('The input directory does not exist!')


        # parse save_fn as needed
        # if len(self.save_fn.get()) != 1:
        #     print('Must put just one value for the save_fn')

        [out_dir,out_files] = os.path.split(self.save_fn.get()) # split directory from rest

    # get directory name
    def get_dir(self):
        self.tiff_dn.set(fd.askdirectory())



if __name__ == "__main__":
    # root window
    root = tk.Tk()
    frm = converter_gui(root)
    root_frame = tk.Frame(root)

    # build it
    root.mainloop()