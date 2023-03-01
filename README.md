<div align="center">
    <img src="https://raw.githubusercontent.com/aionlux/.github/main/resources/img/lg3.png">
    <p> <b>Ailook on Tinker Edge T (TET)</b> </p>
</div>

---------------------------------------------------------------------

This project is about cars plates recognition. The following content concerns setting it up on a Tinker Edge T board.

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