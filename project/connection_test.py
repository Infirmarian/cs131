#!/usr/cs/local/bin/python

import asyncio

async def request(req, port):
    reader, writer = await asyncio.open_connection('127.0.0.1', port)
    writer.write(req.encode("utf-8"))
    data = await reader.read(1000)
    response = data.decode()
    writer.close()
    return response

def main():
    assert(asyncio.run(request("garbage", 11550)) == "? garbage")
    assert(asyncio.run(request("IAMAT bad formatting", 11551)) == "? IAMAT bad formatting")
    x = asyncio.run(request("IAMAT status.geil.com +34.068931-118.445127 1520023934.918963997", 11553))
    res = x.split(" ")
    assert(res[0] == "AT" and res[1] == "Welsh" and res[3] == "status.geil.com" and res[4] == "+34.068931-118.445127")
    assert(asyncio.run(request("WHATSAT not.a.address 2 1", 11552)) == "? WHATSAT not.a.address 2 1")
    x = asyncio.run(request("WHATSAT status.geil.com 2 1", 11554))
    res = x.split(" ")
    assert(res[0] == "AT" and res[1] == "Wilkes" and res[3] == "status.geil.com" and res[4] == "+34.068931-118.445127")
    print("All tests passed")

if __name__ == "__main__":
    main()