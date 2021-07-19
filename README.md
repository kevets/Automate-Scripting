# Automate-Scripting
A collection of helper scripts or solutions used in automations to serve MSP clients

Configure-SonicwallGlobalVPNProfile.ps1
Automation script for populating default connection profiles for Sonicwall Global VPN Client

Remove-SentinelOne
curl https://raw.githubusercontent.com/kevets/Automate-Scripting/master/Remove-SentinelOne.sh 


Needed:
Command line check for macosx agent status
Company Portal app check

View commands
sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl help
sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl restart
sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl status



sudo ls -l /Library/Sentinel/sentinel-agent.bundle

total 3496
drwxr-xr-x  3 root  wheel      96 Jun 30 10:39 SentinelAgent.app
drwxr-xr-x  3 root  wheel      96 Jun 30 10:39 sentinel_shell.app
-rwxr-xr-x  1 root  wheel  669680 May  4 13:41 sentinelctl
drwxr-xr-x  3 root  wheel      96 Jun 30 10:39 sentineld.app
-rwxr-xr-x  1 root  wheel  169936 May  4 13:41 sentineld_browser_host
-rwxr-xr-x  1 root  wheel  438544 May  4 13:41 sentineld_guard
drwxr-xr-x  3 root  wheel      96 Jun 30 10:39 sentineld_helper.app
-rwxr-xr-x  1 root  wheel  232960 May  4 13:41 sentineld_shell
-rwxr-xr-x  1 root  wheel  268880 May  4 13:41 sentineld_updater


Agent
   Version:                 21.5.3.5411
   Install Date:            6/28/21, 9:43:21 AM
   Missing Authorizations:  com.sentinelone.sentineld-helper; com.sentinelone.sentineld; com.sentinelone.sentinel-shell
   ES Framework:            needs authorization (check the documentation)
   FW Extension:            indeterminate
   Ready:                   no
   Protection:              enabled
   Infected:                no
   Network Quarantine:      no


Agent
   Version:                 21.5.3.5411
   Install Date:            6/30/21, 10:39:22 AM
   Missing Authorizations:  com.sentinelone.sentineld-helper; com.sentinelone.sentineld; com.sentinelone.sentinel-shell
   ES Framework:            needs authorization (check the documentation)
   FW Extension:            indeterminate
   Ready:                   no
   Protection:              enabled
   Infected:                no
   Network Quarantine:      no


usage: sentinelctl <subcommand>
	version             	Display version information.
	start               	Start the SentinelOne agent.
	stop                	Stop the SentinelOne agent.
	restart             	Restart the SentinelOne agent.
	uninstall           	Uninstall the SentinelOne agent.
	unprotect           	Disable the SentinelOne agent self-protection.
	protect             	Enable the SentinelOne agent self-protection.
	status              	Show sentineld health status.
	set                 	Set sentineld persistent and runtime configuration.
	config              	Access SentinelOne agent configuration.
	running-commands    	Show all the currently running commands (as received from management).
	assets              	Manage assets.
	scan-on-write       	On-write scanning.
	policies            	Show currently configured policies.
	mitigation-responses	Show the current mitigation responses.
	quarantine          	Manage quarantines.
	remediate           	Remediate a group by ID.
	set-group-status    	Marks the specified group as threat or suspicious (with automatic responses).
	show-threats        	show detected threats.
	firewall            	Firewall Control.
	upgrade-pkg         	Perform an upgrade from the specified package.
	exec                	Executes a script file.
	authenticate        	Enter authenticated mode, to change settings.
	logreport           	Generate a log report; use --upload to upload resulting report to the stored management server. 
	deep-visibility     	Set deep visibility collector configuration.
	locations           	Manage locations.
	copyright           	Show copyright information about open source components used.
	help                	This help text.
	exit                	Exits interactive invocation.
	quit                	Exits interactive invocation.
    