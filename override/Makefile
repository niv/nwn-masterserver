CC     = gcc
OPTS   = -O2 -pipe
DEBUG  =
CFLAGS = -march=i386 -m32 -Wall -Werror -fno-stack-protector $(DEBUG)
LIBS   = -ldl

all: masterserveroverride.so

masterserveroverride.o: masterserveroverride.c
	$(CC) $(CFLAGS) -fPIC -o masterserveroverride.o -c masterserveroverride.c

masterserveroverride.so: masterserveroverride.o
	$(CC) $(CFLAGS) -fPIC -shared -o masterserveroverride.so masterserveroverride.o $(LIBS)

clean:
	/bin/rm -f *.o *.so
