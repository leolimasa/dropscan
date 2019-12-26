#! /bin/bash

if [ -z "${MACHINE_NAME}" ]; then
  MACHINE_NAME="dockerdefault"
fi

# These are brother ADS-2700W specific vendor / product ids
# Run `vboxmanage list usbhost` after setting up virtualbox to list
# vendor ids of connected devices.
if [ -z "${VENDOR_ID}" ]; then
  VENDOR_ID="0x04f9"
fi

if [ -z "${PRODUCT_ID}" ]; then
  PRODUCT_ID="0x03fd"
fi

echo "Product ID: $PRODUCT_ID"
echo "Vendor ID: $VENDOR_ID"

#create and start the machine
docker-machine create -d virtualbox $MACHINE_NAME
 
#We must stop the machine in order to modify some settings
docker-machine stop $MACHINE_NAME
 
#Enable USB
vboxmanage modifyvm $MACHINE_NAME --usb on
 
# OR, if you installed the extension pack, use USB 2.0
vboxmanage modifyvm $MACHINE_NAME --usbehci on
 
# Go ahead and start the VM back up
docker-machine start $MACHINE_NAME
 
# Official Arduinos and many clones use an FTDI chip.
# If you're using a clone that doesn't, 
# or are setting this up for some other purpose
# run this to find the vendor &amp;amp;amp;amp;amp;amp;amp;amp; product id for your device.
# vboxmanage list usbhost
 
# Setup a usb filter so your device automatically gets connected to the Virtualbox VM.
vboxmanage usbfilter add 0 --target $MACHINE_NAME --name ftdi --vendorid $VENDOR_ID --productid $PRODUCT_ID
 
#setup your terminal to use your new docker-machine
#(you must do this every time you want to use this docker-machine or add it to your bash profile)
eval $(docker-machine env $MACHINE_NAME)
