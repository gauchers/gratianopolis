csv := csv/data.csv
tei := tei/data.xml
html := html/data.html

all: $(html)

$(tei): $(csv)
	python py/csv_to_xml.py

$(html): $(tei)
	xsltproc xsl/xml_to_html.xsl $(tei) -o $(html)
