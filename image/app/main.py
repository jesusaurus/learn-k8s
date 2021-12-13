import os
import random
import socket
import time

from fastapi import FastAPI, HTTPException
from math import sqrt


random.seed()
app = FastAPI()


@app.get("/ok")
async def health():
    '''All is well'''
    return True


@app.get("/load")
async def load():
    '''Computationally expensive task'''

    n = 12345
    result = {}

    for i in range(n):
        for j in range(n):
            p = i * j
            if p not in result:
                result[p] = sqrt(p)
        logging.info("Still Working")

    k = random.choice(list(result))
    return {k: result[k]}
