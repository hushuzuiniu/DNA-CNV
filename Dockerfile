FROM ubuntu:20.04

MAINTAINER yuhao<yqyuhao@outlook.com>

RUN sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list

# set timezone
RUN set -x \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get update \
&& apt-get install -y tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone

# install packages
RUN apt-get update \

&& apt-get install -y less curl apt-utils vim wget gcc-7 g++-7 make cmake git unzip dos2unix libncurses5 \

# lib
&& apt-get install -y zlib1g-dev libjpeg-dev libncurses5-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev \
 
# python3 perl java r-base
&& apt-get install -y python3 python3-dev python3-pip python perl openjdk-8-jdk r-base r-base-dev

ENV software /yqyuhao

# create software folder

RUN mkdir -p /data $software/database $software/source $software/target $software/bin

# samtools v1.11
WORKDIR $software/source
RUN wget -c https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 -O $software/source/samtools-1.11.tar.bz2 \
&& tar jxvf samtools-1.11.tar.bz2 \
&& cd samtools-1.11 \
&& ./configure \
&& make \
&& ln -s $software/source/samtools-1.11/samtools $software/bin/samtools

# bwa
WORKDIR $software/source
RUN git clone https://github.com/lh3/bwa.git \
&& cd bwa \
&& make && ln -s $software/source/bwa/bwa $software/bin/bwa

# gatk 4.2.2.0
WORKDIR $software/source
RUN wget -c https://github.com/broadinstitute/gatk/releases/download/4.2.2.0/gatk-4.2.2.0.zip \
&& unzip gatk-4.2.2.0.zip \
&& ln -s $software/source/gatk-4.2.2.0/gatk $software/bin/gatk

# cnvkit v.0.9.9
WORKDIR $software/source
RUN wget -c https://github.com/etal/cnvkit/archive/refs/tags/v0.9.9.tar.gz -O $software/source/cnvkit.v0.9.9.tar.gz \
&& tar -zxvf $software/source/cnvkit.v0.9.9.tar.gz \
&& pip3 install -e $software/source/cnvkit-0.9.9 -i https://mirrors.aliyun.com/pypi/simple \
&& ln -s /usr/local/bin/cnvkit.py $software/bin/cnvkit.py

# bedtools v.2.18.1
WORKDIR $software/source
RUN wget -c https://github.com/arq5x/bedtools2/releases/download/v2.18.1/bedtools-2.18.1.tar.gz -O $software/source/bedtools-2.18.1.tar.gz \
&& tar -zxvf bedtools-2.18.1.tar.gz \
&& cd bedtools2/ \
&& sed -i '112s/const/constexpr/g' src/utils/fileType/FileRecordTypeChecker.h \
&& make clean \
&& make all \
&& ln -s $software/source/bedtools2/bin/bedtools $software/bin/bedtools

# fastp v 0.22.0
WORKDIR $software/source
RUN wget -c https://github.com/OpenGene/fastp/archive/refs/tags/v0.22.0.tar.gz -O $software/source/fastp.v0.22.0.tar.gz \
&& tar -xf fastp.v0.22.0.tar.gz && cd $software/source/fastp-0.22.0 && make \
&& ln -s $software/source/fastp-0.22.0/fastp $software/bin/fastp

# GISTIC 2.0
WORKDIR $software/source
RUN mkdir GISTIC2 && cd GISTIC2 && wget -c ftp://ftp.broadinstitute.org/pub/GISTIC2.0/GISTIC_2_0_23.tar.gz \
&& tar -zxvf GISTIC_2_0_23.tar.gz && rm GISTIC_2_0_23.tar.gz && cd MCR_Installer && unzip MCRInstaller.zip && rm MCRInstaller.zip \
&& ./install -mode silent -agreeToLicense yes -destinationFolder $software/source/GISTIC2/MATLAB_Compiler_Runtime/ \
&& ln -s $software/source/GISTIC2 $software/bin/GISTIC2

# MutSig2CV
WORKDIR $software/source
RUN wget -c https://software.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/MutSig2CV.tar.gz \
&& tar -zxvf MutSig2CV.tar.gz && ln -s $software/source/mutsig2cv $software/bin/mutsig2cv

# matlab R2013a
WORKDIR $software/source
RUN wget -c https://ssd.mathworks.cn/supportfiles/MCR_Runtime/R2013a/MCR_R2013a_glnxa64_installer.zip \
&& unzip MCR_R2013a_glnxa64_installer.zip -d $software/source/mutsig2cv/MCR_R2013a && cd $software/source/mutsig2cv/MCR_R2013a \
&& ./install -mode silent -agreeToLicense yes -destinationFolder $software/source/mutsig2cv/MATLAB_Compiler_Runtime/

# Annovar 2017-07-17
WORKDIR $software/source
RUN git clone https://github.com/hushuzuiniu/bioinfo_file && cd bioinfo_file && unzip annovar_2017-07-17.zip && cd annovar && cp *.pl $software/bin

# ABSOLUTE 1.0.6
WORKDIR $software/source
RUN Rscript -e "install.packages('numDeriv')"
RUN Rscript -e "install.packages('/yqyuhao/source/bioinfo/ABSOLUTE_1.0.6.tar.gz', repos = NULL, type = 'source')"
RUN Rscript -e "install.packages('BiocManager');BiocManager::install('DNAcopy');BiocManager::install('splitstackshape')"

# copy esssential files
WORKDIR $software/source
COPY fastq2stat.pl ABSOLUTE.r YHaoLab_DNApipeline YHaoLab_DNAcallvariantpipeline YHaoLab_pairedDNAcallvariantpipeline clean_data $software/bin/
COPY SureSelect_Human_All_Exon_V6_R2_hg19.bed SureSelect_Human_All_Exon_V6_R2_hg19.cnvkit.bed SureSelect_Human_All_Exon_V6_R2_hg19.anti.cnvkit.bed Twist_Exome_Target_hg19.bed Twist_Exome_Target_hg19.cnvkit.bed Twist_Exome_Target_hg19.anti.cnvkit.bed $software/target/
RUN sed -i '19s/\.\/gp_gistic2_from_seg/\/yqyuhao\/source\/GISTIC2\/gp_gistic2_from_seg/g' $software/source/GISTIC2/gistic2
RUN sed -i '5s#`pwd`#/yqyuhao/source/GISTIC2#g' $software/source/GISTIC2/gistic2

# clean package
WORKDIR $software/source
RUN rm -Rf cnvkit.v0.9.9.tar.gz MutSig2CV.tar.gz bedtools-2.18.1.tar.gz fastp.v0.22.0.tar.gz gatk-4.2.2.0.zip samtools-1.11.tar.bz2 MCR_R2013a_glnxa64_installer.zip annovar bioinfo

# chown root:root
WORKDIR $software/source
RUN chown root:root -R $software/source

# mkdir fastq directory and analysis directory
WORKDIR /data/analysis
