# downloads and unzips all Supreme Court opinions from 2007 to 2012

curl -o scotus-2012.xml.gz -L https://www.courtlistener.com/dump-api/2012/scotus.xml.gz
curl -o scotus-2011.xml.gz -L https://www.courtlistener.com/dump-api/2011/scotus.xml.gz
curl -o scotus-2010.xml.gz -L https://www.courtlistener.com/dump-api/2010/scotus.xml.gz
curl -o scotus-2009.xml.gz -L https://www.courtlistener.com/dump-api/2009/scotus.xml.gz
curl -o scotus-2008.xml.gz -L https://www.courtlistener.com/dump-api/2008/scotus.xml.gz
curl -o scotus-2007.xml.gz -L https://www.courtlistener.com/dump-api/2007/scotus.xml.gz

gzip -d scotus-2012.xml.gz
gzip -d scotus-2011.xml.gz
gzip -d scotus-2010.xml.gz
gzip -d scotus-2009.xml.gz
gzip -d scotus-2008.xml.gz
gzip -d scotus-2007.xml.gz