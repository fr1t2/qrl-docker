FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]

RUN echo "Install dependencies"

RUN apt-get update && \
    apt-get -y install swig3.0 \
                       python3-dev \
                       build-essential \
                       cmake \
                       libhwloc-dev \
                       libboost-dev \
                       ninja-build \
                       pkg-config \
                       software-properties-common

RUN echo "Install gcc5 g++-5"

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get -y install  gcc-5 g++-5

RUN echo "Install Golang"

RUN wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.13.7.linux-amd64.tar.gz \
    && export PATH=$PATH:/usr/local/go/bin \
    && source $HOME/.profile

RUN echo "Install Go-QRL"

RUN go get -d github.com/theQRL/go-qrl \
    && cd $GOPATH/src/github.com/theQRL/go-qrl \
    && make build


# python cmake version requirements may not be needed

#RUN cd /usr/local/src \
#    && wget https://cmake.org/files/v3.10/cmake-3.10.3.tar.gz \
#    && tar xvf cmake-3.10.3.tar.gz \
#    && cd cmake-3.10.3 \
#    && ./bootstrap \
#    && make \
#    && make install \
#    && cd .. \
#    && rm -rf cmake*

#RUN pip3 install -U setupTools
#RUN pip3 install -U qrl

RUN groupadd -g 999 qrl && \
    useradd -r -u 999 -g qrl qrl

RUN mkdir /home/qrl
RUN chown -R qrl:qrl /home/qrl
ENV HOME=/home/qrl
WORKDIR $HOME

USER qrl

# public API
EXPOSE 19009

# admin API
EXPOSE 19008

# mining API
EXPOSE 19007

# debug API
EXPOSE 52134

# grpc proxy
EXPOSE 18090

# wallet daemom
EXPOSE 18091

# wallet api
EXPOSE 19010

# p2p
EXPOSE 19000

# environment variables
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ENTRYPOINT $GOPATH/src/github.com/theQRL/go-qrl/gqrl
