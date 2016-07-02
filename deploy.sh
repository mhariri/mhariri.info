#!/bin/bash

hugo
rsync -va public/ mhariri.info:public_html
