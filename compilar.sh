gradle resolveDeps

gradle build

sudo rm -rf /var/lib/tomcat7/webapps/meeting*

sudo cp build/libs/meeting.war /var/lib/tomcat7/webapps/

sudo service tomcat7 restart
