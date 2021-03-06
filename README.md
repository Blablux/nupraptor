#Nupraptor

Nupraptor is a collection of small shell scripts that do various things.

These scripts are more a sandbox for me to (re)learn Shell programming.

## Scripts list
- `kodidb.sh` is a script that exports a [Kodi](https://kodi.tv) database to
  two csv files, one for movies and one for TV shows.  
  This script can take two parameters :
  - The database path (_required_)
  - The output directory (_optional, defaults to script directory_)
- `mailsrv_backup.sh` is a script that copies, archives and rsync config files
  from a mailserver.  
  This script takes no parameters. It relies on standard path for postfix,
  dovecot, spamassassin and others.
- `websrv_backup.sh` is a script that copies, archives and rsync config files
  from a webserver.  
  This script takes no parameters. It relies on standard path for nginx, php
  and others.
- `clonepi.sh` is a script ultimately designed to replace the specific server
  backup script. It makes a full copy of the SD card to a remote storage,
  allowing for a quick reinstallation.

## Side Note

Nupraptor is the guardian of the pillar of _Mind_ and a NPC from the video
games serie [Legacy of Kain](https://en.wikipedia.org/wiki/Legacy_of_Kain).
