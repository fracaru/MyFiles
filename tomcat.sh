#!/bin/sh
## Starting TOMCAT at boot
TOMCAT_PATH=/opt/apache-tomcat-5.5.26_josso-1.7

## FONCTIONS
function stop {
	#ARRET DU TOMCAT
 	TOMCAT=`ps -ef | grep catalina | awk '{print $2}'` 
 	for pid in $TOMCAT
	do
		kill -9 $pid 2>/dev/null
	done
 	cd $CURRENT_DIR
}
 
function start {
	#DEMARRAGE DU MAP MATCHER
 	cd $TOMCAT_PATH/bin/
 	./josso.sh 
}

function status {
	NB=`ps -ef | grep catalina | wc -l'` 
 	if [ $NB == 2 ]
	then
		echo "Apache Tomcat is running"
	else
 		echo "Apache Tomcat is stopped"
 	fi
}

#######################
# PROGRAMME PRINCIPAL #
#######################

CURRENT_DIR=`pwd`

case $1 in
 start)
	start
	;;
 stop)
	stop
	;;
status)
	status
	;;
restart)
	stop
	start
	;;
 *)
 	echo "Usage : tomcat.sh start|stop|status|restart"
 	exit 1
 	;;
esac
