SOURCES := $(wildcard *.moon)
LUAOUT := $(SOURCES:.moon=.lua)

.PHONY: all run build

all: run

build: $(LUAOUT)

%.lua: %.moon
	moonc $<

run: build
	$(shell luarocks path|sed 's/export //') luajit server.lua
