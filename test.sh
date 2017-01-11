#!/bin/bash
source ./preconfig.sh

rails s -b 0.0.0.0 -p $PORT -e test
