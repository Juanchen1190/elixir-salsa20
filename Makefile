ERLANG_PATH = /usr/local/Cellar/erlang/20.2.2/lib/erlang/erts-9.2/include

salsa20_nif.so : salsa20.o
	cc -fPIC -I/usr/local/Cellar/erlang/20.2.2/lib/erlang/erts-9.2/include -dynamiclib -undefined dynamic_lookup -o salsa20_nif.so salsa20.o salsa20_nif.c

salsa20.o : ecrypt-config.h ecrypt-portable.h ecrypt-machine.h ecrypt-sync.h salsa20.c
	cc -c salsa20.c

clean :
	rm salsa20_nif.so salsa20.o
