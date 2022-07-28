#!/bin/bash

function make_empty_dir()
{
  if [ -z "$1" ];then
    return 0
  fi
  if [ -e "$1" ];then
    rm -rf $1
  fi
  mkdir $1
}

if [ "$1" == "" ];then
  echo "input your gsoap-xxx dir"nn
  echo "usage: $0 gsoap-2.8"
  exit 1
fi
gsoap_dir="$1"
echo "your gsoap_dir $gsoap_dir"

gsoap_para="-I$gsoap_dir/gsoap/ -I$gsoap_dir/gsoap/custom -I$gsoap_dir/gsoap/plugin -I$gsoap_dir/gsoap/import -I$gsoap_dir/gsoap/extras -x "

make_empty_dir output_c
soapcpp2 -c -d output_c/ -C -L $gsoap_para onvif.h

echo "--------------------"

make_empty_dir output_cpp
soapcpp2 -c++ -d output_cpp/ -C -L $gsoap_para onvif.hpp

exit $?
echo "--------------------"
ls output_c -l
echo "--------------------"
ls output_cpp -l


