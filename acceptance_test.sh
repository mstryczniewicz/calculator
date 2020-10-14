#!/bin/bash
test $(curl 192.168.57.6:8765/sum?a=1\&b=4) -eq 5
