#!/bin/bash

USERNAME=$1
HOSTNAME=$2

sh ../shared/partitioning/make-basic-non-efi.sh
sh ../shared/base-install.sh  $USERNAME $HOSTNAME


