#!/bin/bash

if [ "$1" == "" ];then
  echo "input your gsoap-xxx dir"
  echo "usage: $0 gsoap-2.8"
  exit 1
fi
gsoap_dir="$1"
echo "your gsoap_dir $gsoap_dir"

gsoap_para="http://www.onvif.org/onvif/ver10/device/wsdl/devicemgmt.wsdl http://www.onvif.org/onvif/ver10/media/wsdl/media.wsdl http://www.onvif.org/onvif/ver10/event/wsdl/event.wsdl http://www.onvif.org/onvif/ver10/display.wsdl http://www.onvif.org/onvif/ver10/deviceio.wsdl http://www.onvif.org/onvif/ver20/imaging/wsdl/imaging.wsdl http://www.onvif.org/onvif/ver20/ptz/wsdl/ptz.wsdl http://www.onvif.org/onvif/ver10/receiver.wsdl  http://www.onvif.org/onvif/ver10/recording.wsdl http://www.onvif.org/onvif/ver10/search.wsdl http://www.onvif.org/onvif/ver10/network/wsdl/remotediscovery.wsdl http://www.onvif.org/onvif/ver10/replay.wsdl http://www.onvif.org/onvif/ver20/analytics/wsdl/analytics.wsdl http://www.onvif.org/onvif/ver10/analyticsdevice.wsdl http://www.onvif.org/ver10/actionengine.wsdl http://www.onvif.org/ver10/pacs/accesscontrol.wsdl http://www.onvif.org/ver10/pacs/doorcontrol.wsdl http://www.w3.org/2006/03/addressing/ws-addr.xsd"

wsdl2h -o onvif.h -c -s -t $gsoap_dir/gsoap/typemap.dat $gsoap_para

wsdl2h -o onvif.hpp -c++ -s -t $gsoap_dir/gsoap_dir/typemap.dat $gsoap_para

ls onvif* -l

