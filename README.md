#nupraptor

**nupraptor** is a simple project aimed at exporting your xbmc/kodi movies/tvshows database as a simple csv file.

##What it does right now
It uses *xsltproc* to create two csv files : one for movies, the other for TV shows

##What it needs right now
It needs *xsltproc* to apply xslt to the video database. *xsltproc* is a standard package in most unix systems.

##Usage
Export your XBMC / Kodi database as a single file

chmod the script as executable, then run :

 ```./nupraptor.sh (dbfile)```

CSV files are created in the same folder as the database file.
