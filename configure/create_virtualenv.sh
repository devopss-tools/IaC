#!/bin/bash

virtualenv "$1" -p /usr/bin/python3
source "$1/bin/activate"
which python
pip install  --upgrade pip
deactivate
