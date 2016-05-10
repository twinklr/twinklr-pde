#!/usr/bin/env bash
wget https://github.com/twinklr/twinklr_pde/archive/master.zip
unzip master.zip -d .
mv twinklr_pde-master/* .
rmdir twinklr_pde-master
mv io.pde.pi io.pde
