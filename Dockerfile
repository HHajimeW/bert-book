FROM python:3.8

MAINTAINER hajime watanabe

ENV TZ=Asia/Tokyo

ARG work_dir=/app/

WORKDIR $work_dir

COPY ./requirements.txt $work_dir

# SHELLをbashに指定
SHELL ["/bin/bash", "-l", "-c"]

RUN apt-get update \
   && apt-get install -y gcc \
   && apt-get install -y g++

RUN apt-get install -y openjdk-11-jdk

# mecabとmecab-ipadic-NEologdの導入
RUN apt-get update \
   && apt-get install -y mecab \
   && apt-get install -y libmecab-dev \
   && apt-get install -y mecab-ipadic-utf8 \
   && apt-get install -y git \
   && apt-get install -y make \
   && apt-get install -y curl \
   && apt-get install -y xz-utils \
   && apt-get install -y file \
   && apt-get install -y patch \
   && apt-get install -y sudo

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -y | sh
# ENV PATH="/root/.cargo/bin:$PATH"

# RUN sudo apt -y install rustc

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y \
    && sudo cp /etc/mecabrc /usr/local/etc/

RUN pip install --upgrade pip\
   && pip install jupyterlab \
   && pip install -r /app/requirements.txt
COPY . $work_dir

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]