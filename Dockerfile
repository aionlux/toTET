# Base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app

# Updates packages
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y \
    curl \
    gnupg \
    python3.9 \
    python3-pip
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt upgrade -y
RUN apt-get install -y git cmake gcc g++

# Install OpenCV dependencies
RUN apt-get remove --auto-remove python3-opencv && \
    apt-get install -y \ 
    python3-dev && \
    python3-numpy \
    libavcodec-dev libavformat-dev libswscale-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    libgtk-3-dev \
    libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev

RUN git clone https://github.com/opencv/opencv.git /tmp/opencv
RUN cd /tmp/opencv && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make Install

RUN cd /usr/local/lib/python3.9/dist-packages && \
    touch site-packages.pth && \
    echo "../site-packages" >> site-packages.pth

# Install Tesseract dependencies
RUN apt-get update && apt-get install -y \
    libleptonica-dev \
    automake libtool

RUN git clone https://github.com/tesseract-ocr/tesseract.git /tmp/tesseract
RUN cd /tmp/tesseract && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    make training && \
    make training-install
RUN cd /usr/local/share/tessdata
RUN wget https://github.com/tesseract-ocr/tessdata/blob/main/eng.traineddata
RUN wget https://github.com/tesseract-ocr/tessdata/blob/main/osd.traineddata

# Install OpenALPR dependencies
RUN apt-get install -y \
    libopencv-dev \
    libtesseract-dev \
    build-essential \
    libleptonica-dev \
    liblog4cplus-dev \
    libcurl3-dev \
    beanstalkd
  
RUN git clone https://github.com/openalpr/openalpr.git /tmp/openalpr
RUN cd /tmp/openalpr/src && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
    make && \
    make install

# Install more project dependencies
RUN apt-get install -y \
    python3-pyqt5 \
    python3-pandas \
    python3-numpy

RUN python3.9 -m pip install --extra-index-url https://google-coral.github.io/py-repo/ pycoral~=2.0

# RUN mkdir detected && \
#     chmod 775 plates.tfile

# RUN apt-get install xorg -y


# Copy the project files to the working directory
COPY . /app

# Set the default command to run when the container starts
# RUN xhost local:root
CMD ["python3", "run.py"]
