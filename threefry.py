import tvm
import tvm.relay
from tvm import relay
import tvm.testing
import tvm.topi
import numpy as np
import sys
import argparse


def threefry_generate():
    gen = relay.var("gen", relay.TensorType((10,), "uint64"))
    out = relay.random.threefry_generate(gen, (10000000,))
    f = relay.Function([gen], out)
    return relay.create_executor("graph", tvm.IRModule.from_expr(f), target="llvm", device=tvm.cpu()).evaluate()


def threefry_split_generate():
    gen = relay.var("gen", relay.TensorType((10,), "uint64"))
    left, right = relay.TupleWrapper(relay.random.threefry_split(gen), 2)
    out = relay.random.threefry_generate(right, (16,))
    f = relay.Function([gen], out)
    return relay.create_executor("graph", tvm.IRModule.from_expr(f), target="llvm", device=tvm.cpu()).evaluate()


f = threefry_generate()
# f = threefry_split_generate()

gen = tvm.nd.array(np.array([0, 0, 0, 0, 0, 0, 0, 0, 1 << 63, 0], dtype="uint64"))
while True:
    gen, rands = f(gen)
    sys.stdout.buffer.write(bytearray(rands.numpy()))
