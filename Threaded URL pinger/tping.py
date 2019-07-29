import logging
import threading
import time
import random
import requests

def thread_function(url):
	try:
		logging.info("Pinging: {0}.".format(url))
		r = requests.get(url)
		ping = r.elapsed.microseconds/1000
		logging.info("Response from {0} received: {1} {2}".format(url, r.status_code, ping))
	except requests.exceptions.RequestException as e:
		logging.info("Response from {0} received: {1} {2}".format(url, "N/A", "N/A"))


def get_urls():
	with open('targets.txt', 'r') as f:
		urls = f.readlines()
		urls = [line.strip('\n') for line in urls]
		logging.info("URLs found ({0}):{1}".format(len(urls), urls))
		return urls

def main():

	logging.info("STARTING...")

	urls = get_urls()
	threads = []

	for url in urls:
		x = threading.Thread(target=thread_function, args=(str(url),), daemon=True)
		x.start()
		threads.append(x)

	logging.info("WAITING...")

	for i in threads:
		i.join()

	logging.info("DONE")


if __name__ == '__main__':
	format = "%(asctime)s %(filename)s %(thread)d: %(message)s"
	logging.basicConfig(format=format, level=logging.INFO, datefmt="%H:%M:%S")
	main()

