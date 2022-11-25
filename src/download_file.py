# author: Stepan Zaiatc
# date: 2022-11-18

"""Downloading csv file from the web and saving it locally by providing the filepath.
The databases will be downloaded to the out_file path specified.
In this project the data is downloaded into the data/raw folder.

Usage: download_file.py --url=<url> --out_file=<out_file>
Options:
--url=<url>              URL from where to download the data (must be in standard csv format)
--out_file=<out_file>    Path (including filename) of where to locally write the file
"""

from docopt import docopt
import os
import pandas as pd

opt = docopt(__doc__)

def main(url, out_file):
"""
    This main will download the dataset from the default url to the default path
    Parameters
    ----------
    from_url : str
        URL from where to download the dataset (must be in standard csv format)
    out_file : str
        File name with the path where to write the file
  """

  data = pd.read_csv(url, header=None)
  
  os.makedirs(os.path.dirname(out_file))
  data.to_csv(out_file, index = False)
 
if __name__ == "__main__":
  main(opt["--url"], opt["--out_file"])
