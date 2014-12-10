#! /bin/bash
# requirements :
# xsltproc (for XSLT transformation)

function senderror()
{
 echo "$1" ;
  if [ -d "$scriptpath/temp" ]; then
   rm -r "$scriptpath/temp" ;
  fi
 exit 1 ;
}

scriptpath=`dirname $0`
# check if file exist and is XML
if [ ! -z $1 ]; then
  filepath=`dirname $1`
  filename=$(basename "$1")
  ext="${filename##*.}"
  filename="${filename%.*}"
  workingname="$scriptpath"/temp/"$filename"
  if [ ! -r $filepath/$filename.$ext ]; then
    senderror "$filename.$ext can't be read!"
  fi
  if [ "$ext" != "xml" ]; then
    senderror "$filename.$ext is not a XBMC/Kodi database file!"
  fi
else
  senderror "You must supply the file to convert"
fi

mkdir -p $scriptpath/temp

xsltproc movie.xsl $1 > $scriptpath/temp/movies.csv
xsltproc series.xsl $1 > $scriptpath/temp/series.csv
