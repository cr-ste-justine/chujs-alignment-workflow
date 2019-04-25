# Dockerfile to build FASTQC container images
#############################################
# Support for BAMs

FROM openjdk:8-jdk
RUN apt-get update && apt-get install -y unzip wget

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip
RUN unzip fastqc_v0.11.8.zip
RUN rm fastqc_v0.11.8.zip
WORKDIR /FastQC
RUN chmod +x fastqc
CMD ["/FastQC/fastqc"]