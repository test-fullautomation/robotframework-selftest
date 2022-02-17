#
# Regular cron jobs for the dltselftestapp package
#
0 4	* * *	root	[ -x /usr/bin/dltselftestapp_maintenance ] && /usr/bin/dltselftestapp_maintenance
