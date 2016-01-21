#!/bin/bash

hugo
scp -r public/* mhariri.info:public_html/
