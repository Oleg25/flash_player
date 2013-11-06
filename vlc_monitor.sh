#!/bin/sh


export DISPLAY=:0.0
PIDFILE=/home/oleg/vlcd/vlcd.pid
CRIT=70000
recepients="velmisov_oo@rosaski.com,korobov_iv@rosaski.com"


if [ ! -r "$PIDFILE" ] ; then
    echo "CRITICAL - PID file ($PIDFILE) not exists or not readable. Restarting VLCD"
    /etc/init.d/vlcd restart
    exit 0
fi


vlcpid=`cat /home/oleg/vlcd/vlcd.pid`
proc=`ps p "$vlcpid" -o rss=,vsz= | sed -e "s/\..*//"`

if [ -z "$proc" ] ; then
    echo "CRITICAL - process vlc rosa with given PID is not running. Restarting VLCD"
    /etc/init.d/vlcd restart
    exit 0
fi

mem=`echo "$proc" |awk '{print $1;}'`
mempct=`echo "$proc" |awk '{print $2;}'`

if [ "$mem" -ge "$CRIT" ]; then
    echo "From:vlc_monitor\nSubject:streaming server alarm\nCRITICAL limit of memory = $mem Kb" | /usr/sbin/sendmail "$recepients"
    /etc/init.d/vlcd restart
    exit 0
fi


status_tcp=`nc -z 172.17.4.29 4212 ; echo $?`

if [ "$status_tcp" -eq "1" ]; then
    echo "From:vlc_monitor\nSubject:streaming server alarm\ntelnet interface of vlc not responding in time" | /usr/sbin/sendmail "$recepients"
    /etc/init.d/vlcd restart
    exit 0
fi


exit 0
