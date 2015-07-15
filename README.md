# ispmail-util
tiny shell script for managing the mysql database connected to the ["ispmail" dovecot/postfix setup](https://workaround.org/ispmail/wheezy setup)

Please note that I exchanged the md5 password hashes as per the comments on [that page](https://workaround.org/ispmail/wheezy/preparing-the-database) and that my script assumes that setup. Here's the changes:
```
DROP TABLE virtual_users;
CREATE TABLE `virtual_users` (
`id` int(11) NOT NULL auto_increment,
`domain_id` int(11) NOT NULL,
`password` varchar(106) NOT NULL,
`email` varchar(100) NOT NULL,
PRIMARY KEY (`id`),
UNIQUE KEY `email` (`email`),
FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
Also one line in ``/etc/dovecot/dovecot-sql.conf.ext``
```
default_pass_scheme = SHA512-CRYPT
```

###Usage
```
Usage: admin.sh <u|d|a> <list|add|delete> [name/email] [password/id/email]
u=virtual_users, d=virtual_domains, a=virtual_aliases

./admin.sh d list
./admin.sh d add domain.com
./admin.sh d add domain.com 42
./admin.sh d delete domain.com

./admin.sh u list
./admin.sh u add user@domain.com
./admin.sh u delete user@domain.com

./admin.sh a list
./admin.sh a add source@domain.com target@otherdomain.com
./admin.sh a delete source@domain.com
```
