#!/usr/bin/env bash
rm -f master.zip
wget https://github.com/twinklr/twinklr_pde/archive/master.zip
unzip master.zip -d .
rm -rf data
mv -f twinklr_pde-master/* .
rm -rf twinklr_pde-master
mv -f io.pde.pi io.pde
