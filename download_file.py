#download_file
"""Downloading csv file from the web and saving it locally by providing the filepath.
Usage: download_file.py --url=<url> --out_file=<output_file_name_path>
Options:
--url=<url>                              URL from where to download the data (the file needs to be in standard csv format).
--output_file=<output_file_name_path>    Path and the filename of where to write the file locally.
"""

from docopt import docopt
import requests
import os
import pandas as pd

opt = docopt(__doc__)

def main(url, out_file):

  request = requests.get(url)

  data_file = pd.read_csv(url, header=None)
  
  try:
    data_file.to_csv(out_file, index = False)
  except:
    os.makedirs(os.path.dirname(out_file))
    data_file.to_csv(out_file, index = False)
 
if __name__ == "__main__":
  main(opt["--url"], opt["--out_file"])