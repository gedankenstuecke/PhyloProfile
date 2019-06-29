FROM jupyter/datascience-notebook:8a1b90cbcba5

RUN pip install --no-cache-dir notebook==5.*

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN mkdir ~/src # (optional, only when the folder not exists)
RUN cd ~/src
RUN wget https://ftp.gwdg.de/pub/misc/cran/src/base/R-3/R-3.6.0.tar.gz
RUN tar xvfz R-3.6.0.tar.gz
RUN cd R-3.6.0
RUN ./configure --prefix=/home/jovyan/R/3.6.0 --enable-memory-profiling --enable-R-shlib --with-blas --with-cairo --with-lapack --with-x=yes
RUN make -j4
RUN make install


RUN export LD_LIBRARY_PATH=/home/jovyan/R/3.6.0/lib:$LD_LIBRARY_PATH
RUN export MANPATH=/home/jovyan/R/3.6.0/man:$MANPATH
RUN export JAVA_HOME=/share/applications/java/java8
RUN export PATH=/home/jovyan/R/3.6.0/bin:$JAVA_HOME/bin:$PATH

RUN source ~/.bashrc

RUN R -e "install.packages(c('PhyloProfile'), repos = 'http://cran.us.r-project.org')"


