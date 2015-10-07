#/bin/bash
salt="$(/usr/bin/bbb-conf --salt|grep Salt|cut -c13-44)" 
sed -i "s|bced839c079b4fe2543aefa73c7f6a57|$salt|" $HOME/dev/bigbluebutton-0.9.1/bigbluebutton-meeting/src/main/webapp/bbb_api_conf.jsp

