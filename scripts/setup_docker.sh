#!/bin/bash
apt-get update
apt-get install -y imagemagick
apt-get install -y tesseract-ocr
apt-get install -y tesseract-ocr-eng
apt-get install -y sane
dpkg -i /root/brscanads2200ads2700w-0.1.15-1.amd64.deb
