#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <stdarg.h>

#include <fcntl.h>
#include <time.h>
#include <string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <netdb.h>

#define __USE_GNU
#include <dlfcn.h>

#include "masterserveroverride.h"

struct hostent *gethostbyname (const char *host) {
	static char *he_aliases[] = { NULL };

	static char *he_gamespy_addrs[] = { MASTERSERVER, NULL };
	static char *he_bioware_addrs[] = { MASTERSERVER, NULL };

	static struct hostent *(*ghbn)(const char *) = NULL;

	if (ghbn == NULL)
		ghbn = dlsym(RTLD_NEXT, "gethostbyname");

	static struct hostent he_gamespy = {
		.h_name = "nwn.master.gamespy.com",
		.h_aliases = he_aliases,
		.h_addrtype = 2,
		.h_length = 4,
		.h_addr_list = he_gamespy_addrs
	};

	static struct hostent he_bioware = {
		.h_name = "nwmaster.bioware.com",
		.h_aliases = he_aliases,
		.h_addrtype = 2,
		.h_length = 4,
		.h_addr_list = he_bioware_addrs
	};

	if (strcmp(host, "nwn.master.gamespy.com") == 0)
		return &he_gamespy;
	if (strcmp(host, "nwmaster.bioware.com") == 0)
		return &he_bioware;

	return ghbn(host);
}
