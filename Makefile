OPENSSL_DIR = /usr/local/Cellar/openssl/1.0.2n
PCRE_DIR =  /usr/local/Cellar/pcre/8.42

LIB_DIRS = -L$(OPENSSL_DIR)/lib -L$(PCRE_DIR)/lib 

LIBS = $(LIB_DIRS) -lpcre -lcrypto -lm -lpthread 
CFLAGS_BASE = -I$(OPENSSL_DIR)/include -I$(PCRE_DIR)/include
CFLAGS=$(CFLAGS_BASE) -ggdb -O3 -Wall
OBJS=vanitygen.o oclvanitygen.o oclvanityminer.o oclengine.o keyconv.o pattern.o util.o
PROGS=vanitygen keyconv oclvanitygen oclvanityminer
PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
OPENCL_LIBS=-framework OpenCL
else
OPENCL_LIBS=-lOpenCL
endif


most: vanitygen keyconv

all: $(PROGS)

vanitygen: vanitygen.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

oclvanitygen: oclvanitygen.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

oclvanityminer: oclvanityminer.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS) -lcurl

keyconv: keyconv.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
