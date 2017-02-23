# ispmail-util
tiny shell script for managing the mysql database connected to the ["ispmail" dovecot/postfix setup for debian](https://workaround.org/ispmail/)

###Usage
```
Usage: admin.sh <u|d|a> <list|add|delete> [name/email] [password/id/email]
u=virtual_users, d=virtual_domains, a=virtual_aliases

./admin.sh d list
./admin.sh d add domain.com
./admin.sh d add domain.com 42
./admin.sh d delete domain.com

./admin.sh u list
./admin.sh u add user@domain.com passw0rd
./admin.sh u delete user@domain.com

./admin.sh a list
./admin.sh a add source@domain.com target@otherdomain.com
./admin.sh a delete source@domain.com
```
Keep in mind that you can use catchall aliases as per the tutorial
```
./admin.sh a add @domain.com target@otherdomain.com
```
