#!/bin/bash
STAGING_SERVER="$1"
test $(curl "$STAGING_SERVER":8765/sum?a=1\&b=4) -eq 5
