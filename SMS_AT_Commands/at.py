import serial
import time
import random
import sys
from datetime import datetime

#-----------------------------------

delay_l = 7
delay_u = 36
numbers_filename = "18_numbers.txt"
operator = "Telia"
comport = "COM5"
message = "Test message from " + operator + ". -ElisaOyj"
message = message.encode() + b'\r'

#-----------------------------------

def load_numbers():
    numbers = []
    with open(numbers_filename, "r") as f:
        numbers = f.read().splitlines()
    return numbers

def printer(message):
    now = datetime.now().isoformat()
    print("> " + str(now) + " " + str(message))

def countdown(d):
    for s in range(d,0,-1):
        sys.stdout.write("\r")
        sys.stdout.write("> " + str(s) + " ")
        sys.stdout.flush()
        time.sleep(1)
    sys.stdout.write("\r")
    printer("Waiting done.")
    sys.stdout.flush()

def sendmessages(numbers):
    nokia = serial.Serial(port=comport,baudrate=9600,timeout=1,rtscts=0,xonxoff=0)
    nokia.write(b'AT+CMGF=1\r')
    time.sleep(0.1)
    #TODO: Warning if o != "OK"
    o = nokia.readline()

    for i in numbers:

        # Get index and length
        ci = numbers.index(i) + 1
        l = len(numbers)

        if i.startswith("358"):
            i = "+" + i

        # AT: Set destination number
        printer("Destination " + str(i) + " (" + str(ci) + "/" + str(l) + ")")
        cmgs = b'AT+CMGS="' + bytes(str(i), encoding='utf-8') + b'"\r'
        nokia.write(cmgs)
        time.sleep(0.5)
     
        # AT: Send message
        printer("Sending a message...")
        nokia.write(message)
        nokia.write(bytes([26]))
        
        # RESULT
        delay = random.randint(delay_l, delay_u)
        printer("Waiting... [Delay: " + str(delay) + "]")
        
        countdown(delay)

        x = "Sent: " + str(i)
        #TODO: Read lines in loop and store to array
        #TODO: Read until line feed (or two etc.)
        a = nokia.readline()
        time.sleep(0.1)
        b = nokia.readline()
        time.sleep(0.1)
        c = nokia.readline()
        time.sleep(0.1)
        d = nokia.readline()
        time.sleep(0.1)
        e = nokia.readline()
        time.sleep(0.1)
        f = nokia.readline()

        #TODO: Output handler...
        printer((x + " |", a, b, c, d, e, f))
        print()

    nokia.close()

def main():
    numbers = load_numbers()
    print()
    for n in numbers:
        print("LOADED: " + str(n))

    print()
    print("-" * (len(str(message)) + 9))
    print("Operator: " + operator)
    print("Message: " + str(message))
    print("Port: " + comport)
    print("-" * (len(str(message)) + 9))
    print()

    cmd = input("Looking good? Continue? (y): ")
    print()

    if cmd.lower() == "y":
        print("> Preparing...")
        print()
        sendmessages(numbers)
    else:
        print("Exiting...")
        exit()

    print("> Done.")

if __name__ == '__main__':
    main()

