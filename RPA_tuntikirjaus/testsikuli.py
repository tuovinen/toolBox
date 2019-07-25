import subprocess
import datetime
import re

# Hae aikaleima CMD:n 'quser' komennolla
proc = subprocess.Popen('quser', shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
out, err = proc.communicate()
# Aikaleiman erotus muusta regexillä
out_timestamp = re.findall("\d{1,2}.\d{1,2}.\d{4}.*", out)

# Päivämäärä ja aika omiin muuttujiin
out_date = out_timestamp[0].split(' ')[0]
out_time = out_timestamp[0].split(' ')[1]

# Päättymisaika
end_time = datetime.datetime.now().time()
end_time = end_time.strftime("%H:%M")

print("Found logon date and time: {0} {1}".format(out_date, out_time))

click("1564059615965.png")
wait("1564059639128.png")
click("1564059639128.png")
type("https://pytest101.herokuapp.com/leimaus/" + Key.ENTER)
wait("1564059732213.png")
type(Pattern("1564059732213.png").targetOffset(59,-39), out_date)
type(Pattern("1564059732213.png").targetOffset(65,-12), out_time)
type(Pattern("1564059732213.png").targetOffset(53,10), end_time)
sleep(1)
click(Pattern("1564059732213.png").targetOffset(-7,40))
wait("1564059950351.png")
sleep(2)


