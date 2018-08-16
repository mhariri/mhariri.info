#!/bin/bash

hugo
rsync -va public/ mhariri.info:www/mhariri.info
