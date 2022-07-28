#include <iostream>
#include "wsdd.nsmap"
#include "soapH.h"
using namespace std;
int main()
{
    struct soap *soap;
    struct wsdd__ProbeType req;
    struct __wsdd__ProbeMatches resp;
    struct wsdd__ScopesType sScope;
    struct SOAP_ENV__Header header;
    int count = 0;
    int result = 0; 

    char guid_string[100];

     soap = soap_new(); 
    if(soap==NULL)
    {
        return -1;
    }
 
    soap_set_namespaces(soap, namespaces); 

    soap->recv_timeout = 5;		//超过5秒钟没有数据就退出
    soap_default_SOAP_ENV__Header(soap, &header);
 
    header.wsa__MessageID = guid_string;
    header.wsa__To= "urn:schemas-xmlsoap-org:ws:2005:04:discovery";
    header.wsa__Action= "http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe";
    soap->header = &header;

    soap_default_wsdd__ScopesType(soap, &sScope);
    sScope.__item = "";
    soap_default_wsdd__ProbeType(soap, &req);
    req.Scopes = &sScope;
    req.Types = "";

    result = soap_send___wsdd__Probe(soap, "soap.udp://239.255.255.250:3702", NULL, &req);

    do{
         result = soap_recv___wsdd__ProbeMatches(soap, &resp); 
         if (soap->error) 
         { 
             cout<<"soap error:"<<soap->error<<soap_faultcode(soap)<<"---"<<soap_faultstring(soap)<<endl; 
             result = soap->error; 
             break;
         } 
         else
         {
            cout<<"========================================="<<endl;
 
            cout<<"Match size:"<<resp.wsdd__ProbeMatches->__sizeProbeMatch<<endl;
            cout<<"xsd-unsignedInt:"<<resp.wsdd__ProbeMatches->ProbeMatch->MetadataVersion<<endl;
            cout<<"scopes item:"<<resp.wsdd__ProbeMatches->ProbeMatch->Scopes->__item<<endl;
            //cout<<"scopes matchby:"<<resp.wsdd__ProbeMatches->ProbeMatch->Scopes->MatchBy<<endl;
            cout<<"QName:"<<resp.wsdd__ProbeMatches->ProbeMatch->Types<<endl;
            cout<<"xsd:string:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.Address<<endl;
            cout<<"xsd:QName:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.PortType<<endl;
            cout<<"wsa:ServiceNameType:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.ServiceName<<endl;
            cout<<"sequence of elements:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.__size<<endl;
            cout<<"xsd:anyType:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.__anyAttribute<<endl;
            cout<<"endpoint any:"<<resp.wsdd__ProbeMatches->ProbeMatch->wsa__EndpointReference.__any<<endl;
            cout<<"wsdd:UriListType:"<<resp.wsdd__ProbeMatches->ProbeMatch->XAddrs<<endl;
         }
     }while(1);

    soap_destroy(soap); // remove deserialized class instances (C++ only) 
    soap_end(soap);		// clean up and remove deserialized data
    soap_done(soap);

    return result;
} 