FROM rocker/tidyverse:4.2.2

WORKDIR /interop

# Required to use wget in the environment.
RUN apt-get update
RUN apt-get install -y wget

# Get Interop command line tools.
RUN wget https://github.com/Illumina/interop/releases/download/v1.1.25/InterOp-1.1.25-Linux-GNU.tar.gz 
RUN tar -xf *.gz --strip-components 1
RUN rm *.gz

# Add to PATH.
# Source: https://stackoverflow.com/questions/27093612/in-a-dockerfile-how-to-update-path-environment-variable
ENV PATH="/interop/bin/:${PATH}"

RUN R -e "install.packages('devtools')"
