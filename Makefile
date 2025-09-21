SRCDIR = src
BUILDDIR = build
OUTPUTEXE = game

CC = g++
CFLAGS = -m64 -fno-strict-aliasing -pedantic -Wall -Wextra -Wno-deprecated-declarations -Wno-unused-parameter -Wno-format-truncation -std=c++11 -pthread -DOS_LINUX=1 -DARCH_X64=1
LFLAGS = -Wl,-t -lcrypto

DEBUG ?= 0
ifneq ($(DEBUG), 0)
	CFLAGS += -g -Og -DENABLE_ASSERTIONS=1
else
	CFLAGS += -O2
endif

HEADERS = $(SRCDIR)/common.hh $(SRCDIR)/communication.hh $(SRCDIR)/config.hh $(SRCDIR)/connections.hh $(SRCDIR)/containers.hh $(SRCDIR)/cr.hh $(SRCDIR)/crypto.hh $(SRCDIR)/enums.hh $(SRCDIR)/houses.hh $(SRCDIR)/info.hh $(SRCDIR)/magic.hh $(SRCDIR)/map.hh $(SRCDIR)/moveuse.hh $(SRCDIR)/objects.hh $(SRCDIR)/operate.hh $(SRCDIR)/query.hh $(SRCDIR)/reader.hh $(SRCDIR)/script.hh $(SRCDIR)/threads.hh $(SRCDIR)/writer.hh

$(BUILDDIR)/$(OUTPUTEXE): $(BUILDDIR)/communication.obj $(BUILDDIR)/config.obj $(BUILDDIR)/connections.obj $(BUILDDIR)/cract.obj $(BUILDDIR)/crcombat.obj $(BUILDDIR)/crmain.obj $(BUILDDIR)/crnonpl.obj $(BUILDDIR)/crplayer.obj $(BUILDDIR)/crskill.obj $(BUILDDIR)/crypto.obj $(BUILDDIR)/houses.obj $(BUILDDIR)/info.obj $(BUILDDIR)/magic.obj $(BUILDDIR)/main.obj $(BUILDDIR)/map.obj $(BUILDDIR)/moveuse.obj $(BUILDDIR)/objects.obj $(BUILDDIR)/operate.obj $(BUILDDIR)/query.obj $(BUILDDIR)/reader.obj $(BUILDDIR)/receiving.obj $(BUILDDIR)/script.obj $(BUILDDIR)/sending.obj $(BUILDDIR)/shm.obj $(BUILDDIR)/strings.obj $(BUILDDIR)/threads.obj $(BUILDDIR)/time.obj $(BUILDDIR)/utils.obj $(BUILDDIR)/writer.obj
	$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)

$(BUILDDIR)/communication.obj: $(SRCDIR)/communication.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/config.obj: $(SRCDIR)/config.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/connections.obj: $(SRCDIR)/connections.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/cract.obj: $(SRCDIR)/cract.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crcombat.obj: $(SRCDIR)/crcombat.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crmain.obj: $(SRCDIR)/crmain.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crnonpl.obj: $(SRCDIR)/crnonpl.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crplayer.obj: $(SRCDIR)/crplayer.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crskill.obj: $(SRCDIR)/crskill.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/crypto.obj: $(SRCDIR)/crypto.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/houses.obj: $(SRCDIR)/houses.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/info.obj: $(SRCDIR)/info.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/magic.obj: $(SRCDIR)/magic.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/main.obj: $(SRCDIR)/main.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/map.obj: $(SRCDIR)/map.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/moveuse.obj: $(SRCDIR)/moveuse.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/objects.obj: $(SRCDIR)/objects.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/operate.obj: $(SRCDIR)/operate.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/query.obj: $(SRCDIR)/query.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/reader.obj: $(SRCDIR)/reader.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/receiving.obj: $(SRCDIR)/receiving.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/script.obj: $(SRCDIR)/script.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/sending.obj: $(SRCDIR)/sending.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/shm.obj: $(SRCDIR)/shm.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/strings.obj: $(SRCDIR)/strings.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/threads.obj: $(SRCDIR)/threads.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/time.obj: $(SRCDIR)/time.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/utils.obj: $(SRCDIR)/utils.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/writer.obj: $(SRCDIR)/writer.cc $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) -o $@ $<

.PHONY: clean

clean:
	@rm -rf $(BUILDDIR)

