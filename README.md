# sdp-wastewater

Calculate and extract the required metadata fields for the RADx-rad Wastewater RNA-Seq project


Dictionaries used:
- https://docs.google.com/spreadsheets/d/1G49OvMocM8BC4VvQ_XH6CBYYXN3a6sZ23t8KcGgIQfM/edit?usp=sharing 
- https://docs.google.com/spreadsheets/d/1Lq5G_J4mggpmeqDGryKwBbHUDoXzF_zx/edit?usp=sharing&ouid=110084142835466802195&rtpof=true&sd=true


## Build the Docker
```shell
docker pull rocker/tidyverse:4.2.2
docker build -t sdp-interop:0.0.1 .
```


## Run the code:

```shell
docker run --rm \
-v <RUN_LOCAL_FOLDER>:/data_raw/  \
-v <CONSTANTS_LOCAL_FOLDER>:/constants_folder/ \
-v <OUTPUT_LOCAL_FOLDER>:/data_output/ \
sdp-interop:0.0.1  Rscript /constants_folder/Wasterwater_Processing.R 
```

<RUN_LOCAL_FOLDER> : the local directory where the run folder is located (e.g. 
<CONSTANTS_LOCAL_FOLDER> :
<OUTPUT_LOCAL_FOLDER> : 
