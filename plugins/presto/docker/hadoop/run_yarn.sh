#!/bin/sh

PATH=$PATH:/opt/hadoop/bin

yarn resourcemanager&
yarn nodemanager
