#!/bin/bash

# ==============================================
# Export a Kodi video database to csv
# First argument is the path to the database
# Second argument (optional) is the output directory path. If unused, the
# database path will be used instead
# ==============================================

function senderror()
{
 echo "$1" ;
 exit 1 ;
}

# check if file exists and is a database
if [ ! -z "$1" ]; then
  filepath=$(dirname "$1")
  filename=$(basename "$1")
  ext="${filename##*.}"
  filename="${filename%.*}"
  if [ ! -r "$filepath"/"$filename"."$ext" ]; then
    senderror "$filename.$ext can't be read!"
  fi
  if [ "$ext" != "db" ]; then
    senderror "$filename.$ext is not a XBMC/Kodi database file!"
  fi
else
  senderror "You must supply the file to convert"
fi
# check if output path exists
if [ ! -z "$2" ]; then
  outputpath="$2"
  if [ ! -d "$outputpath" ]; then
    senderror "$outputpath can't be read!"
  fi
else
  outputpath=$filepath
fi
echo $outputpath
# check if output files already exists
if [ -r "$outputpath"/movies.csv ]; then
  echo "Output file for movies already exists. Overwrite ? (y/n)"
  read movieswrite
  if [ "$movieswrite" == "y" ]; then
    rm "$outputpath"/movies.csv
  else
    senderror "Could not write movies export file, exiting."
  fi
fi

echo "Processing movies...";

echo -e '.headers on\n.mode csv\n.once "'"$outputpath"'/movies.csv"\nselect movie.c00 as "Titre", movie.c07 as "Année", movie.c14 as "Genre", movie.c15 as "Réalisateur", date(files.dateAdded) as "Ajout" from movie join files on files.idFile=movie.idFile order by "Ajout" desc;' | sqlite3 "$filepath"/"$filename"."$ext"

if [ -r "$outputpath"/series.csv ]; then
  echo "Output file for series already exists. Overwrite ? (y/n)"
  read serieswrite
  if [ "$serieswrite" == "y" ]; then
    rm "$outputpath"/series.csv
  else
    senderror "Could not write series export file, exiting."
  fi
fi

echo "Processing series...";

echo -e '.headers on\n.mode csv\n.once "'"$outputpath"'/series.csv"\nselect tvshow.c00 as "Serie", count(distinct episode.c12) as "Saisons", count(episode.c13) as "Episodes", tvshow.c08 as "Genre" from episode join files on files.idFile=episode.idFile join tvshow on tvshow.idShow=episode.idShow group by tvshow.c12 order by tvshow.c00 asc;' | sqlite3 "$filepath"/"$filename"."$ext"
