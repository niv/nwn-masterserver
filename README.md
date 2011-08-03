What's this?
============

This is a complete replacement for the masterserver Bioware runs on
nwmaster.bioware.com.

This project originated out of a need to have custom authentication hooks
and be indepentent of third-party downtimes.

The code herein is mostly a stub, and will need significant customisation to
suit your local setup.


Requirements & Installation
---------------------------

Currently, nwn-masterserver requires the following gems to be installed:

* eventmachine
* arpie (>= 0.0.6)
* sequel (& libsqlite3-ruby) (if you want to use the example SQL handler)

To install, simply check out the current git master and copy config.yaml.example
to config.yaml. Edit to suit your needs.



Getting your server to talk to your own master server
-----------------------------------------------------

You can run the masterserver on the same host as your game server, and you
do not need to make it available to the internet for it to work (unless you
plan to write a passthrough module or similar). Depending on your setup, you
will have to change the default port from 5121 to something else, or bind
the masterserver to a different IP.

### /etc/hosts (requires root)

The simplest way is to redirect by editing /etc/hosts. Just put

	127.0.0.1 nwmaster.bioware.com

Adjust IP to match, if running on a different host.

### LD_PRELOAD

There's a LD_PRELOADable patch provided in override/ of the source tree.

- Edit the header file to match your IP address (in hex notation)
- Compile it
- Start your server with <tt>LD_PRELOAD=./masterserveroverride.so nwserver</tt>

The preloadable should be compatible with any other, including nwnx2.

### via iptables (requires root)

If, for some reason, neither option works for you, you can also use iptables
to redirect all traffic to your masterserver host:

	iptables -t nat -A OUTPUT -p udp -d 204.50.199.9     -j DNAT --to your.masterserver:5121
	iptables -t nat -A PREROUTING -p udp -d 204.50.199.9 -j DNAT --to your.masterserver:5121



Getting clients to talk to your master server (optional)
--------------------------------------------------------

The masterserver is fully compatible to both authenticating clients directly and
via nwserver. You can direct your clients via the same tricks above.
