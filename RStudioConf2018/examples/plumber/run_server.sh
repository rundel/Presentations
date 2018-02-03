#!/bin/bash

while ! Rscript run.R
do
  sleep 1
  echo "Plumber server exited ..."
done