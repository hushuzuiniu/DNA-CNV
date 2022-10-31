# YhaoLab Pipeline
We provides complete solutions for secondary DNA analysis for a variety of sequencing platforms, including short and long reads. Our pipeline improves upon fastp (Version 0.22.0), BWA (Version 0.7.17), samtools (Version 1.11), bedtools (Version 2.18.1), GATK (Version 4.2.2.0), Mutect2 (Version 4.2.2.0), Annovar (Version 2017-07-17), CNVkit (Version 0.9.9), GISTIC2 (Version 2.0), MutSig2CV (Version 3.11) and Absolute (Version 1.06) based pipelines and is deployable on any generic-CPU-based computing system. 
# Install
This repository contains instructions on how to build and run a docker image containing the scripts.

To run the module, first clone the repository, CD into the 'bioinfo' directory and build the docker container using the dockerfile there:

git clone https://github.com/yqyuhao/bioinfo.git

cd bioinfo 

docker build . -t yqyuhao/bioinfo or docker pull yqyuhao/bioinfo
