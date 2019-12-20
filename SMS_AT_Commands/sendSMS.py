import serial
import time
import sys
from datetime import datetime as dt

def main():

	# Nokia e52 plugged in USB port (COM8)
	nokia = serial.Serial(port="COM8",baudrate=9600,timeout=1,rtscts=0,xonxoff=0)
	nokia.write(b'AT+CMGF=1\r')

	running = True
	while running:
		cmd = input("number > ")
		number = cmd

		cmgs = b'AT+CMGS="+' + bytes(str(number), encoding='utf-8') + b'"\r'

		nokia.write(cmgs)
		nokia.write('Testi'.encode() + b'\r')
		nokia.write(bytes([26]))
		print("sent: " + str(number))
		time.sleep(1)

		a = nokia.readline()
		b = nokia.readline()
		c = nokia.readline()
		d = nokia.readline()
		e = nokia.readline()

		print(a, b, c, d, e)

		cmd = input("Uuvvestaan? (y/n)")
		if cmd.lower() != "y":
			running = False
			nokia.close()
			print("EOS.")
		else:
			pass


if __name__ == '__main__':
	main()