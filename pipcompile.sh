#!/bin/bash

set -eux

python3 -m pip install pip-tools
python3 -m piptools compile requirements.in
