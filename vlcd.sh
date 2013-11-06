#!/bin/sh
#
### BEGIN INIT INFO
# Provides:          vlcd
# Required-Start:    $network
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:	     0 6
# Short-Description: VLC Rosa Khutor IP cameras
# Description:       This service provides streaming
#                    rosa khutor IP cameras to network
### END INIT INFO

set -e

. /lib/lsb/init-functions

#mkdir -p /var/run/vlcd
#test -e /var/run/vlcd/vlcd.pid || touch /var/run/vlcd/vlcd.pid
#chown oleg:oleg /var/run/vlcd/
#chmod 777 /var/run/vlcd/vlcd.pid


VLCD_PIDDIR=/home/oleg/vlcd
VLCD_LOGDIR=/var/log/vlcd


[ -r /etc/default/vlcd ] && . /etc/default/vlcd



# Logging options
VLC_LOG="--file-logging --logmode text --logfile $VLCD_LOGDIR/vlcd.log"

verbose()
{

   log_daemon_msg "Starting VLC rosa daemon in verbose mode"

   export DISPLAY=:0
   cvlc -I dummy  -I luaintf --lua-intf ip_cameras --ttl=5 --telnet-host 172.17.4.29 --telnet-port 4212 --telnet-password 654456  --extraintf telnet  --network-caching=12000 --ffmpeg-format=mxg "/home/oleg/pl.xspf" --loop --sout='#transcode{vcodec=FLV1,vb=950,fps=16,width=1024,height=768}:gather:std{access=http{mime=video/x-flv},mux=ffmpeg{mux=flv},dst=172.17.4.29:9090/stream.flv}'-- $VLC_LOG --pidfile $VLCD_PIDDIR/vlcd.pid
   log_end_msg $?

}

start()
{
	log_daemon_msg "Starting VLC rosa daemon"

        export DISPLAY=:0
	vlc -d -I luaintf --lua-intf ip_cameras --ttl=5 --telnet-host 172.17.4.29 --telnet-port 4212 --telnet-password 654456  --extraintf telnet  --network-caching=12000 --ffmpeg-format=mxg "/home/oleg/pl.xspf" --loop --sout='#transcode{vcodec=FLV1,vb=950,fps=16,width=1024,height=768}:gather:std{access=http{mime=video/x-flv},mux=ffmpeg{mux=flv},dst=172.17.4.29:9090/stream.flv}'-- $VLC_LOG --pidfile $VLCD_PIDDIR/vlcd.pid
	log_end_msg $?
}

stop()
{
        log_daemon_msg "Stopping VLC rosa daemon"
        start-stop-daemon --stop --exec /usr/bin/vlc --oknodo --pidfile $VLCD_PIDDIR/vlcd.pid  --retry=TERM/5/KILL/5 
        #pkill vlc
	log_end_msg $?


}
case "$1" in
    --diag)
     verbose
    ;;
    start)
	start
	;;
    restart|force-reload)
	stop
	sleep 2
	start
	;;
    stop)
	stop
	;;
    status)
	exit 4
	;;
    *)
	echo "Usage: /etc/init.d/vlcd {start|stop}"
	exit 2
	;;
esac

exit 0
