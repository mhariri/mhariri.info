#!/bin/bash

hugo
aws --profile private s3 cp public s3://www.mhariri.info/ --recursive
