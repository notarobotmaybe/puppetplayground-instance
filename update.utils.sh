#!/bin/bash

CURRENT_WD=$(pwd)

# puppetboard - https://github.com/voxpupuli/puppetboard

if [ ! -d './puppetboard/.git' ];
then
  git clone https://github.com/voxpupuli/puppetboard
  git checkout v0.3.0
fi

docker images | grep "eyp/voxpopuli-puppetboard" > /dev/null 2>&1

if [ $? -ne 0 ];
then
  cd "./puppetboard"
  docker build -t eyp/voxpopuli-puppetboard .
fi

cd $CURRENT_WD

if [ ! -d "./utils" ];
then
  echo "utils directory not found"
  exit 1
fi

if [ ! -d "./utils/puppet-masterless/.git" ];
then
  cd "./utils"
  rm -fr puppet-masterless
  git clone https://github.com/jordiprats/puppet-masterless
else
  cd "./utils/puppet-masterless"
  git pull origin master
fi

cd $CURRENT_WD

if [ ! -d "./utils/autocommit/.git" ];
then
  cd "./utils"
  rm -fr autocommit
  git clone https://github.com/jordiprats/autocommit
else
  cd "./utils/autocommit"
  git pull origin master
fi

cd $CURRENT_WD
