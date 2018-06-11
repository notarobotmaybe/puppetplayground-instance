#!/bin/bash

CURRENT_WD=$(pwd)

if [ ! -d "./utils" ];
then
  echo "utils directory not found"
  exit 1
fi

if [ ! -d "./utils/puppet-masterless" ];
then
  cd "./utils"
  git clone https://github.com/jordiprats/puppet-masterless
else
  cd "./utils/puppet-masterless"
  git pull origin master
fi

cd $CURRENT_WD
