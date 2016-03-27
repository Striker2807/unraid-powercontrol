# Introduction #

Adds /sbin/powerdown script to assist with quick unRAID poweroff,

Adds /etc/rc.d/rc.unRAID script to capture runlevel changes and issue associated commands.

Also captures syslog and diagnostic commands during shutdown or on demand to /boot/logs.

# Installation Details #

This is a standard slackware install package.
Download and install to /boot/packages.

Install with:

installpkg /boot/packages/powerdown-1.02.tgz

Add the line above to your /boot/config/go script to do this automatically upon each reboot.

Install with VAR's as defined above like:

VAR=YES OTHERVAR=YES installpkg powerdown-#.##-noarch-unRAID.tgz

Like:

CTRLALTDEL=yes installpkg powerdown-#.##-noarch-unRAID.tgz

Prefix variable options are as follows
  * CTRLALTDEL=yes set ctrl-alt-del to do powerdown instead of reboot
  * SYSLOG=YES     do initial syslog saving upon installation
  * STATUS=YES     Show status upon installation
  * START=YES      do initial start upon installation

/etc/rc.d/rc.unRAID script has basic pre-power down functions.

Hooks are placed in /etc/rc.d/rc.local\_shutdown
to allow ormal poweroff/shutdown commands do a graceful shutdown.

Diagnostic mode for quick syslog dump/save to /boot/logs
call as /etc/rc.d/rc.unRAID syslog.