import re
import os

directory = "F:\\robotti\\data\\"

for filename in os.listdir(directory):
    with open(directory + filename) as f:
        data = f.read()

        if "Muutos:" in data:
            print("MUUTOS: " + filename)

        if "Poisto:" in data:
            print("POISTO: " + filename)

        if "Uusi:" in data:

            rows = data.split("\n")

            recdate = rows[0]

            customer_name = re.findall('Asiakkaan nimi: (.*)', data)
            
            service_name = re.findall('(Elisa .*)\(M\)', data)

            service_name[0] = service_name[0].strip()

            service_package = re.findall('-alkuisella lyhytsanomanumerolla: \n(.*)', data)

            admin_name = re.findall('Nimi: (.*)', data)
            admin_email = re.findall('Sähköpostiosoite: (.*)', data)
            admin_phone = re.findall('Matkapuhelinnumero: (.*)', data)

            try:
                print(recdate + ";" + customer_name[0] + ";" + service_name[0] + " / " + service_package[0] + ";" + filename + ";" + admin_name[0] + ";" + admin_email[0] + ";" + admin_phone[0])
            except:
                print("LOMAKE RIKKI: " + filename + ": " + service_name[0])