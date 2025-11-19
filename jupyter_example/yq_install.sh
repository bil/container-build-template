#!/bin/bash

#installs yq package, which is required to process instructions yaml
wget -nv https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ~/.local/bin/yq 
chmod +x ~/.local/bin/yq

