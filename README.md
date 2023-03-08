<div align="center">
    <img src="https://raw.githubusercontent.com/aionlux/.github/main/resources/img/lg3.png">
    <p> <b>Ailook on Tinker Edge T (TET)</b> </p>
</div>

---------------------------------------------------------------------

This project is about cars plates recognition. The following content concerns setting it up on a Tinker Edge T board.

- Prerequisites
    - [Install Tinker Edge T Software](https://github.com/aionlux/toTET#install-tinker-edge-t-software)
    - [Install OpenCV](https://github.com/aionlux/toTET#install-opencv)
    - [Install Tesseract](https://github.com/aionlux/toTET#install-tesseract)
    - [Install Openalpr](https://github.com/aionlux/toTET#install-openalpr)

## Install Tinker Edge T Software

To Incorporate the Tinker edge T environment (software) it’s important to go to the following forum URL to download it:

 https://tinker-board.asus.com/forum/index.php?/forum/5-software/

Then we need to unpackage it, Install the driver `android_winusb.inf` locate on:

```
Tinker_Edge_T-Mendel-Eagle-V3.0 2-20201015\tools\ASUS_Android_USB_drivers_for_Windows\Windows_XP_VISTA_7_8_8.1\Android
```

when the above is finished, we have to connect our PC to Tinker Edge T (with USB-C) and execute `flash.cmd` on windows or `flash.sh` on Linux.

### Configure SSH into Tinker Edge T

It's important to maintain the connection between the PC  and TET. So we are going to continue with installing:


```
py -m pip install --user mendel-development-tool
```

This allows us to SSH into TET:

```
mdt devices
mdt shell
```

### Internet, timezones, update, and upgrade

When we want to connect our TET to the internet we just have to type `nmtui` this display a UI that allows us to interact with many available networks.

If we want to change the time zone, we can do it like this:

```bash
timedatectl list-timezones
```

The above will display timezones, we have to figure out our country `<zone>` and then type:

```bash
sudo timedatectl set-timezone <zone>
sudo timedatectl set-ntp yes
sudo reboot
```

Also, we have to update packages:

```bash

sudo apt-get update
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt upgrade
```

It's necessary to download git:
```
sudo apt-get install git
```

## Install OpenCV

These steps are based on how to install OpenCV in Ubuntu. The easy way to download is by typing `sudo apt-get install python3-opencv`, but this doesn't work very well with tesseract (that is what we will need to install also). So the correct way is the following.

```bash
sudo apt-get remove --auto-remove python3-opencv
sudo apt-get install cmake
sudo apt-get install gcc g++
sudo apt-get install python3-dev python3-numpy
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
sudo apt-get install libgtk-3-dev
sudo apt-get install libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev
```

Then we will continue to clone the OpenCV repository:


```bash
git clone https://github.com/opencv/opencv.git
cd opencv
mkdir build
cd build
sudo make ../
sudo make
```

It's possible we have an error during `sudo make` running, to fix it we have to follow the steps on: https://linuxize.com/post/how-to-add-swap-space-on-debian-10/

if The above step is done we continue with the following:

```bash
sudo make install
```

To import OpenCV in our script we have to create a file named `site-packages.pth`:

```bash
cd /usr/local/lib/python3.7/dist-packages
sudo vim site-packages.pth
```

and copy:

```text
../site-packages
```

Now we can use OpenCV like this:

```python
import cv2 as cv
print(cv.__version__)
```

The complete installation is here: https://docs.opencv.org/3.4/d2/de6/tutorial_py_setup_in_ubuntu.html

## Install Tesseract

Before to clone Tesseract repository it's important install these requierements:

```bash
sudo apt-get install libleptonica-dev
sudo apt-get install automake libtool
```

Now we can clone repositpry from https://github.com/tesseract-ocr/tesseract

```bash
git clone https://github.com/tesseract-ocr/tesseract.git
```

When the above is done, we continue doing the following:

```bash
cd tesseract
sudo ./autogen.sh
sudo ./configure
sudo make
sudo make install
sudo ldconfig
sudo make training
sudo make training-install
```

We hahe to download some traineddata:

```bash
cd /usr/local/share/tessdata
sudo wget https://github.com/tesseract-ocr/tessdata/blob/main/eng.traineddata
sudo wget https://github.com/tesseract-ocr/tessdata/blob/main/osd.traineddata
```

To test if this works go to https://tesseract-ocr.github.io/tessdoc/Command-Line-Usage.html#simplest-invocation-to-ocr-an-image

The complete descrption about this installation is here: https://github.com/tesseract-ocr/tesseract/blob/main/INSTALL.GIT.md

## Install Openalpr

We have to install prerequisites

```bash
sudo apt-get install libopencv-dev libtesseract-dev git cmake build-essential libleptonica-dev
sudo apt-get install liblog4cplus-dev libcurl3-dev
sudo apt-get install beanstalkd
```
Then we have to clone the repository:

```bash
git clone https://github.com/openalpr/openalpr.git
```

To setup follow these steps:

```bash
cd openalpr/src
mkdir build
cd build
sudo cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc ..
sudo make
sudo make install
```

If you want to test:

```bash
sudo wget http://plates.openalpr.com/h786poj.jpg -O lp.jpg
alpr lp.jpg
```

or

```bash
cd openalpr/src/bindings/python/
sudo python3 setup.py install
sudo wget http://plates.openalpr.com/h786poj.jpg -O lp.jpg
sudo python3 test.py -c au lp.jpg   # au is a country (in this case australia)
```

The installation is the easiest way to install Openalpr, there are other ways, and we can found them here: https://github.com/openalpr/openalpr/wiki/Compilation-instructions-(Ubuntu-Linux)


## Run Script

To run the script before we have to ensure all prerequisites are installed. So we have to clone this repository:

```bash
git clone https://github.com/aionlux/toTET.git
```

The script will need some extra dependencies such as `pyqt5`, `pycoral`, `pandas`, `numpy` libraries. First it's necesary update and upgrade.

```bash
sudo apt-get update
sudo apt upgrade
sudo apt-get install python3-pyqt5
sudo apt-get install python3-pycoral
sudo apt-get install python3-pandas
sudo apt-get install python3-numpy
```

Then we will go to `./toTET`, create a directory called `detected`, change mode of `plates.tflite`, and install `xorg`. If for some cases we need to open an image we will use `feh` (it's optional)

```bash
cd toTET
sudo mkdir detected
sudo chmod 775 plates.tflite
sudo apt-get install xorg
sudo apt-get install feh
```

It's almost done. Before to run la script `run.py` we have to execute.

```bash
xhost local:root
```

Now

```
sudo python3 run.py
```



