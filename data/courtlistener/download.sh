for jurisdiction in scotus ca1 ca2 ca3 ca4 ca5 ca6 ca7 ca8 ca9 ca10 ca11 cadc cafc; do
  for i in {1980..2012}; do 
    if [ -f $jurisdiction-$i.xml ];
      then
        echo "File already exists. Skipping download."
      else
        echo "Downloading..."
        curl -o $jurisdiction-$i.xml.gz -L https://www.courtlistener.com/dump-api/$i/$jurisdiction.xml.gz
    fi
  done

  for i in {1980..2012}; do 
    if [ -f $jurisdiction-$i.xml ];
      then 
        echo "File already unzipped. Skipping unzip."
      else
        gzip -d $jurisdiction-$i.xml.gz
    fi
  done
done