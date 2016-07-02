#!/bin/bash

hugo
rsync -vr public mhariri.info:public_html
