
This ONLY works with the ADS-2700W scanner so far, and only on USB.

# Setup

## Mac OS

We need to forward the USB from the Mac to the Docker container. To do that we run docker inside virtualbox with USB forwarding:

1. Install virtual box
1. Install the virtual box extension pack
1. Run setup_mac.sh

See https://christopherjmcclellan.wordpress.com/2019/04/21/using-usb-with-docker-for-mac/#tldr for more info.

# Usage

## Platform specific command

```
dropscan_[mac|win|linux] [prefix]
```

Where prefix is the name of the file to be generated for the scan.

## To run the image directly from docker

```
docker run -t dropscan:latest
```

## To access the image command line

If running mac, first do a `setup_docker_machine` then `eval $(docker-machine env default)` to enable the env.

```
docker run -i -t dropscan:latest /bin/bash
```

## To build the image

```
docker build -t dropscan .
```

# Gotchas

## Can't identify usb device on mac

`docker-machine` creates a new virtualbox machine that runs on Tiny Core Linux. We have to know if the USB device detected there matches the device we are passing on the docker command line. For that we need to log into the machine via the virtualbox console, and then:

1. Install `usb-utils.tcz` by using `tce-ab`
1. Use `lsusb` and ensure the scanner is listed there.
1. Do `find /sys/bus/usb/devices/usb*/ -name dev`. This will tell you all the folders that have `dev` files, which means they are devices. BUT we don't need the actual files, only the directories, so do this to get the directories: `find /sys/bus/usb/devices/usb*/ -name dev | rev | cut -c 4- | rev` 
1. Then use `udevadm` to get the path in `/dev` where the device is mounted. Ex: 
`udevadm info -q property --export -p /sys/bus/usb/devices/usb1/1-1`

Short version:

```
find /sys/bus/usb/devices/usb*/ -name dev | rev | cut -c 4- | rev | xargs -I {} udevadm info -q property -p {} | less
```

Source: https://unix.stackexchange.com/questions/144029/command-to-determine-ports-of-a-device-like-dev-ttyusb0
