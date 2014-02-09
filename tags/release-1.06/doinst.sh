#!/bin/bash

config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

[ ${DEBUG:=0} -gt 0 ] && set -x -v 

#for i in config.new 
#do # config etc/$i; 
#done

SD_RCFILE=/etc/rc.d/rc.local_shutdown
RCFILE=/etc/rc.d/rc.unRAID

if ! grep ${RCFILE} ${SD_RCFILE} >/dev/null 2>&1
   then echo -e "\n\n[ -x ${RCFILE} ] && ${RCFILE} stop\n" >> ${SD_RCFILE}
fi

[ ! -x ${SD_RCFILE} ] && chmod u+x ${SD_RCFILE}


if [ ! -z "${CTRLALTDEL}" ];then 
   sed --in-place=.bak -e 's/shutdown .*/powerdown/g' /etc/inittab
   /sbin/telinit q
fi

if [ ! -z "${START}" ];then 
   ${RCFILE} start
fi

if [ ! -z "${SYSLOG}" ];then 
   ${RCFILE} syslog
fi

if [ ! -z "${STATUS}" ];then 
   ${RCFILE} status
fi

if [ ! -z "${HDPARM}" ];then 
   sed --in-place=.bak -e "s/HDPARM=.*/HDPARM=${HDPARM}/g" ${RCFILE}
fi

if [ ! -z "${SMARTCTL}" ];then 
   sed --in-place=.bak -e "s/SMARTCTL=.*/SMARTCTL=${SMARTCTL}/g" ${RCFILE}
fi

if [ ! -z "${LOGDIR}" ];then 
   sed --in-place=.bak -e "s/LOGDIR=.*/LOGDIR=${LOGDIR}/g" ${RCFILE}
fi

if [ ! -z "${LOGSAVE}" ];then 
   sed --in-place=.bak -e "s/LOGSAVE=.*/LOGSAVE=${LOGSAVE}/g" ${RCFILE}
fi

if [ ! -z "${RCDIR}" ];then
   sed --in-place=.bak -e "s/RCDIR=.*/RCDIR=${RCCDIR}/g" ${RCFILE}
fi

if [ ! -z "${LOGROTATE}" ];then 
   if ! grep ${RCFILE} /etc/logrotate.conf > /dev/null 2>&1
    then IFS="
"
	   while read LINE
	   do echo "${LINE}"
		  if [ "${LINE}" = "/var/log/syslog {" ]
			 then echo "    prerotate"
				  echo "       ${RCFILE} syslog"
				  echo "    endscript"
				  echo "    compress"
		  fi
		done < /etc/logrotate.conf    > /etc/logrotate.conf.tmp
		cat < /etc/logrotate.conf.tmp > /etc/logrotate.conf
		rm -f /etc/logrotate.conf.tmp
   fi
fi


# Joe L. & Weebotech Addition for power handler script.
# sysctl -w kernel.poweroff_cmd="/sbin/powerdown"

# http://lime-technology.com/forum/index.php?topic=2068.msg18287#msg18287
# Joe L's mechanism for chaning the power handler"
# sed -i -e "s/init 0/powerdown/" /etc/acpi/acpi_handler.sh   
