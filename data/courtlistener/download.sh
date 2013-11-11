for jurisdiction in scotus ca1 ca2 ca3 ca4 ca5 ca6 ca7 ca8 ca9 ca10 ca11 cadc cafc; do
  for i in {1980..2012}; do 
    curl -o $jurisdiction-$i.xml.gz -L https://www.courtlistener.com/dump-api/$i/$jurisdiction.xml.gz
  done

  for i in {1980..2012}; do 
    gzip -d $jurisdiction-$i.xml.gz
  done
done