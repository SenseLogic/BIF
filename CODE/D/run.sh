#!/bin/sh
set -x
dmd -debug -g -gf -gs -m64 -oftest test.d color.d stream.d stream_field.d stream_state.d && ./test
