#!/bin/bash
source ./preconfig.sh

nohup rails s -b 0.0.0.0 -p $PORT -e production &
