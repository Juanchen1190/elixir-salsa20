MIX = mix
CFLAGS = -g -O3 -ansi -pedantic -Wall -Wextra -Wno-unused-parameter

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)
CFLAGS += -std=gnu99 -Wno-unused-function

# ifeq ($(wildcard deps/salsa20),)
# SALSA20_PATH = ../salsa20
# else
# SALSA20_PATH = deps/salsa20
# endif

# CFLAGS += -I$(SALSA20_PATH)/src

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

.PHONY: all salsa20 clean

all: salsa20

salsa20:
	$(MIX) compile

priv/salsa20_nif.so: priv/salsa20.o
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ priv/salsa20.o src/salsa20_nif.c

priv/salsa20.o: src/ecrypt-config.h src/ecrypt-portable.h src/ecrypt-machine.h src/ecrypt-sync.h src/salsa20.c
	$(CC) -c src/salsa20.c -o priv/salsa20.o

clean:
	$(MIX) clean
	$(RM) -r priv/salsa20_nif.so* priv/salsa20.o

# ERLANG_PATH = /usr/local/Cellar/erlang/20.2.2/lib/erlang/erts-9.2/include

# salsa20_nif.so : salsa20.o
# 	cc -fPIC -I/usr/local/Cellar/erlang/20.2.2/lib/erlang/erts-9.2/include -dynamiclib -undefined dynamic_lookup -o salsa20_nif.so salsa20.o salsa20_nif.c

# salsa20.o : ecrypt-config.h ecrypt-portable.h ecrypt-machine.h ecrypt-sync.h salsa20.c
# 	cc -c salsa20.c

# clean :
# 	rm salsa20_nif.so salsa20.o
