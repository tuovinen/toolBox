import logging
import threading
import time
import random

def thread_function(name):
	logging.info("Starting thread {0}.".format(name))
	time.sleep(random.randint(1,5))
	logging.info("Thread {0} ready.".format(name))

format = "%(asctime)s %(filename)s %(thread)d: %(message)s"
logging.basicConfig(format=format, level=logging.INFO, datefmt="%H:%M:%S")

threads = []

for i in range(0,5):
	logging.info("Creating thread: " + str(i))
	x = threading.Thread(target=thread_function, args=str(i))
	x.start()
	threads.append(x)

logging.info("WAITING...")

for i in threads:
	i.join()

logging.info("DONE")


