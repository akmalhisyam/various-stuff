# Original - https://stackoverflow.com/questions/3548495/download-extract-and-read-a-gzip-file-in-python
# Python2
import urllib2, gzip, StringIO

url = 'https://covid-19-threat-list.domaintools.com/dt-covid-19-threat-list.csv.gz'

out_file_path = url.split("/")[-1][:-3]
response = urllib2.urlopen(url)
compressed_file = StringIO.StringIO(response.read())
decompressed_file = gzip.GzipFile(fileobj=compressed_file)

with open(out_file_path, 'w') as outfile:
    outfile.write(decompressed_file.read())
