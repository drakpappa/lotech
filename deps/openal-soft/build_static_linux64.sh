#!/bin/sh
mkdir -p build
rm -rf build/*
cd build
cmake -DLIBTYPE=STATIC -G "Unix Makefiles" ..
cat config.h | sed 's/\#define AL_API .*$/\#define AL_API/' | sed 's/\#define ALC_API .*$/\#define ALC_API/' > config.h.tmp
mv config.h.tmp config.h
make
