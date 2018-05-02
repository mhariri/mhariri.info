#!/bin/bash

hugo
rsync -va public/ mhariri.info_new:www/mhariri.info
