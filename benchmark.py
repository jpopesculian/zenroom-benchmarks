import os.path
import zenroom
import json


def import_script(name):
    filename = os.path.join(
        os.path.dirname(__file__),
        "contracts",
        "%s.lua" % name
    )
    file = open(filename, 'r')
    res = file.read()
    file.close()
    return res


GENKEY = import_script("genkey")
SIGN = import_script("sign")
VERIFY = import_script("verify")


def genkey():
    output, _ = zenroom.execute(GENKEY)
    return json.loads(output)


def sign(keys, message):
    output, _ = zenroom.execute(
        SIGN,
        json.dumps(keys),
        json.dumps({"message": message})
    )
    out = json.loads(output)
    return out['r'], out['s']


def verify(keys, r, s, message):
    output, errors = zenroom.execute(
        VERIFY,
        json.dumps(keys),
        json.dumps({
            "message": message,
            "r": r,
            "s": s,
        })
    )
    return json.loads(output)['verified']


message = "This is a message"
keys = genkey()
r, s = sign(keys, message)
# assert(verify(keys, r, s, message))


times = 100


def loop_gen_key():
    for i in range(times):
        print("genkey ", i)
        genkey()


def loop_sign():
    for i in range(times):
        print("sign ", i)
        sign(keys, message)


def loop_verify():
    for i in range(times):
        print("verify ", i)
        verify(keys, r, s, message)


if __name__ == "__main__":
    loop_gen_key()
    loop_sign()
    loop_verify()
