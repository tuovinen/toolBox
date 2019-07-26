import os
from datetime import datetime as dt
from flask import Flask
from flask import request


app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
	qs = request.query_string
	
	if request.headers.getlist("X-Forwarded-For"):
   		ip = request.headers.getlist("X-Forwarded-For")[0]
	else:
   		ip = request.remote_addr

	response_string = "<START>" + ip + "," + dt.now().isoformat() + "," + qs.decode() + "<END>"

	return response_string

if __name__ == '__main__':
	port = int(os.environ.get('PORT', 5000))
	app.run(host='0.0.0.0', port=port, debug=True)

