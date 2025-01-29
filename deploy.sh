#!/bin/sh
allflag=

while getopts ":a" option
do
    case $option in
    a)    allflag=1;;
    ?)    echo "Usage: $0 [-a]\n -a: upload both public and draft webs\n"; exit;;
    esac
done

if [ ! -z "$allflag" ]; then
echo "***********************************************************"
echo "* This action will overwrite the current muirst public web *"
read -r -p "* Are you sure? [y/N] " response
case $response in
    ([yY][eE][sS]|[yY]) 
      ;;
    *)
      exit;;
esac
fi

TUNNEL="ssh -p 15001 -l lbt idefix.dit.upm.es ssh"
LOCALDIR="docs/"
PUBLICREMOTE="posgrado:/home/posgrado/lib/www/muirst"
DRAFTREMOTE="posgrado:/home/posgrado/lib/www/muirst-draft"

# Create public site using ssh forwarding tunnel 
if [ ! -z "$allflag" ]; then
echo "Creating public site dit.upm.es/posgrado/muirst"
rsync -avz -e "$TUNNEL" --exclude-from rsync-exclude.txt --delete $LOCALDIR $PUBLICREMOTE
fi

# Create draft site using ssh forwarding tunnel 
echo "Creating draft site dit.upm.es/posgrado/muirst-draft"
rsync -avz -e "$TUNNEL" --exclude-from rsync-exclude.txt --delete $LOCALDIR $DRAFTREMOTE

exit 0

