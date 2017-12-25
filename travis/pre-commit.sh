#!/bin/bash -xe
source ~/virtualenv/python2.7/bin/activate
python --version
pip install --upgrade pip setuptools
pip install pre-commit
pre-commit run -a
