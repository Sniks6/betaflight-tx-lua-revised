CRSF_ADDRESS_BETAFLIGHT=0xC8;CRSF_ADDRESS_RADIO_TRANSMITTER=0xEA;CRSF_FRAMETYPE_MSP_REQ=0x7A;CRSF_FRAMETYPE_MSP_RESP=0x7B;CRSF_FRAMETYPE_MSP_WRITE=0x7C;crsfMspCmd=0;crsfMspHeader={}protocol.mspSend=function(a)local b={CRSF_ADDRESS_BETAFLIGHT,CRSF_ADDRESS_RADIO_TRANSMITTER}for c=1,#a do b[c+2]=a[c]end;return crossfireTelemetryPush(crsfMspCmd,b)end;protocol.mspRead=function(d)crsfMspCmd=CRSF_FRAMETYPE_MSP_REQ;return mspSendRequest(d,{})end;protocol.mspWrite=function(d,a)crsfMspCmd=CRSF_FRAMETYPE_MSP_WRITE;return mspSendRequest(d,a)end;protocol.mspPoll=function()local e,f=crossfireTelemetryPop()if e==CRSF_FRAMETYPE_MSP_RESP then if f[1]==CRSF_ADDRESS_RADIO_TRANSMITTER and f[2]==CRSF_ADDRESS_BETAFLIGHT then local g={}for c=3,#f do g[c-2]=f[c]end;return mspReceivedReply(g)end end;return nil end
