#!/usr/cs/local/bin/python
import uuid
import json
import time
import asyncio
import aiohttp
import sys
import socket
import logging


# Ports allocated to me on the Seasnet Servers
port_map = {
    "Golomon": 11550,
    "Hands": 11551,
    "Holiday": 11552, 
    "Welsh": 11553, 
    "Wilkes": 11554
}
connection_map = {
    "Golomon": [ "Hands", "Holiday", "Wilkes" ],
    "Hands": ["Golomon", "Wilkes"],
    "Holiday": ["Welsh", "Wilkes", "Golomon"],
    "Wilkes" : ["Golomon", "Hands", "Holiday"],
    "Welsh": ["Holiday"]
}
location_lists = {}
message_ids = set()

def load_api_key():
    with open("api.txt", "r") as f:
        key = f.readline()
    return key[:-1]



def main():
    if len(sys.argv) != 2:
        print("Error, incorrect number of arguments provided", file=sys.stderr)
        exit(1)
    global server_name
    server_name = sys.argv[1]
    if server_name not in port_map:
        print("Error, unrecognized server name {} provided".format(server_name), file=sys.stderr)
        exit(1)
    print(server_name)
    logging.basicConfig(format='[%(levelname)s] '+server_name+' %(asctime)s : %(message)s', filename=server_name+".log", level=logging.INFO)
    key = load_api_key()
    loop = asyncio.get_event_loop()
    coro = asyncio.start_server(handle_request, '127.0.0.1', port_map[server_name], loop=loop)
    server = loop.run_until_complete(coro)

    # Serve requests until Ctrl+C is pressed
    print('Serving on {}'.format(server.sockets[0].getsockname()))

    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    # Close the server
    server.close()
    loop.run_until_complete(server.wait_closed())
    loop.close()

def gps_split(gps_string):
    neg = gps_string.rfind("-")
    pos = gps_string.rfind("+")
    s_pos = max(pos, neg)
    result = []
    result.append(float(gps_string[:s_pos]))
    result.append(float(gps_string[s_pos:]))
    return result

async def propagate_server_message(msg):
    others = connection_map[server_name]
    values = msg.split(" ")

    for name in others:
        port = port_map[name]
        try:
            reader, writer = await asyncio.open_connection('127.0.0.1', port)
            writer.write(msg.encode("utf-8"))
            await writer.drain()
            writer.close()
            logging.info("Forwarded client {} info to server {} on port {}".format(values[1], name, port))
        except:
            logging.error("Unable to communicate with server {} on port {}".format(name, port))

async def handle_request(reader, writer):
    data = await reader.read(100)
    now = time.time()
    message = data.decode()
    fwd_message = ""
    values = message.strip("\n").split(" ")
    try:
        if values[0] == "IAMAT":
            addr = values[1]
            gps = gps_split(values[2])
            sent_time = float(values[3])
            time_diff = now - sent_time
            time_print = "+"+str(time_diff) if time_diff > 0 else str(time_diff)
            result = "AT {name} {time_diff} {addr} {gps} {time}\n".format(name=server_name, time_diff=time_print,
            addr=addr, gps=values[2], time=sent_time)

            # Store the name and location into the server
            location_lists[addr] = gps
            logging.info("IAMAT message from {}".format(addr))

            # Propagate information to other servers
            message_id = uuid.uuid4()
            fwd_message = "CLIENTAT {name} {gps} {uuid} {server}".format(name=addr, gps=values[2], uuid=message_id, server=server_name)
            message_ids.add(message_id)

        elif values[0] == "WHATSAT":
            result = "hello\n".encode('utf-8')
        
        elif values[0] == "CLIENTAT":
            if values[3] in message_ids:
                result = "0"
            else:
                location_lists[values[1]] = gps_split(values[2])
                logging.info("Received a location update from server {} on client {}".format(values[4], values[1]))
                await propagate_server_message(message)
                result = "1"
        else:
            raise Exception
    except:
        result = "? "+message
    encoded = result.encode("utf-8")

    writer.write(encoded)
    await writer.drain()
    writer.close() 
    
    # Propagate messages foward to other servers
    if fwd_message != "":
        await propagate_server_message(fwd_message)


if __name__ == "__main__":
    main()
