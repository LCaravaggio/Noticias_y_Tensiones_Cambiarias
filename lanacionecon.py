from bs4 import BeautifulSoup
import requests
import csv
from contextlib import suppress

with open('lanacionecon3.csv', 'w', newline="\n", encoding='utf-8') as f:
		for anio in range(23,25):
			anio1=1994 + anio
			anio2=1995 + anio
			print("Año: " + str(anio1))
			for i in range(1,1000):
				print("Pagina: " + str(i))
				with suppress(Exception):
					r = requests.get("https://buscar.lanacion.com.ar/economia/date-"+ str(anio1) + "0217,"+ str(anio2) +"0217" + "/page-" + str(i))
				soup = BeautifulSoup(r.content, 'html.parser')
				
				for li_tag in soup.find_all('li', {'class':'floatFix notas'}):
					c=""
					a=li_tag.a.get_text("href").replace('"','').replace(';',',')
					b=li_tag.p.get_text("").replace(';',',')
					with suppress(Exception):
						c=li_tag.find('div',{'class':'data'}).get_text("").replace('|',';')
					f.write(a + ";" + b + ";" + c +  "\n")
				i+=1	
			anio+=1
f.close