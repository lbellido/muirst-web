#!/bin/sh
TUNNEL="ssh -p 15001 -l lbt idefix.dit.upm.es ssh"
LOCALDIR="docs/"
PUBLICREMOTE="muirst:/home/muirst/lib/www"
DRAFTREMOTE="muirst:/home/muirst/lib/www/draft"
allflag=

echo "*************************************************"
echo "* All permissions of  $LOCALDIR will be changed *"
read -r -p "* Are you sure? [y/N] " response
case $response in
    ([yY][eE][sS]|[yY]) 
      ;;
    *)
      exit;;
esac

find $LOCALDIR -type f -exec chmod 644 {} \; 
find $LOCALDIR -type d -exec chmod 755 {} \; 

chmod g+s $LOCALDIR

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



# Create public site using ssh forwarding tunnel 
if [ ! -z "$allflag" ]; then
echo "Creating public site dit.upm.es/muirst"
rsync -avz -e "$TUNNEL" --exclude-from rsync-exclude.txt --delete $LOCALDIR $PUBLICREMOTE
echo "https://www.dit.upm.es/~muirst updated"
fi

# Create draft site using ssh forwarding tunnel 
echo "Creating draft site dit.upm.es/muirst/draft"
rsync -avz -e "$TUNNEL" --exclude-from rsync-exclude.txt --delete $LOCALDIR $DRAFTREMOTE

echo "https://www.dit.upm.es/~muirst/draft updated. Please check the draft site and, if everything is correct, run this script with the -a option to update the public site."
exit 0

