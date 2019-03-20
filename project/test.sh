#!/bin/bash
python3 server.py Golomon  >/dev/null &
python3 server.py Hands  >/dev/null &
python3 server.py Holiday  >/dev/null &
python3 server.py Welsh >/dev/null &
python3 server.py Wilkes >/dev/null &
# Wait for all servers to come up
sleep 3

python3 connection_test.py


# Kill the servers after test completion
ps | grep "\(python3\)\|\(server.py\)" | awk {'print $1'} | xargs kill &>/dev/null

