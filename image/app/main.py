import os
import random
import socket
import time

from fastapi import BackgroundTasks, FastAPI
from math import sqrt


random.seed()
app = FastAPI()


def compute():
    '''Computationally expensive task'''

    n = 12345
    result = {}

    for i in range(n):
        for j in range(n):
            p = i * j
            if p not in result:
                result[p] = sqrt(p)


@app.get("/ok")
async def health():
    '''All is well'''
    now = time.ctime()
    return f"Hello World, the current time is {now}"


@app.get("/load")
async def load(bgt: BackgroundTasks):
    '''Trigger some computation'''
    bgt.add_task(compute)
    return {"Work": "Scheduled"}
