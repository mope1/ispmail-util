MIN_ARGS=2
E_BADARGS=65
if [ $# -lt $MIN_ARGS ]; then
  echo "Usage: `basename $0` <u|d|a> <list|add|delete> [name/email/source] [password/id/email/destination]"
  echo "u=virtual_users, d=virtual_domains, a=virtual_aliases"
  exit $E_BADARGS
fi

read -s -p "mysql password: " mysqlpw 

function getdomainid() {
    domain=$(echo $email | perl -pe "s/.*@(.*)/\1/")
    read placeholder domainid <<< $(mysql -p$mysqlpw "mailserver" -e "select id from virtual_domains d where d.name='$domain';")
    echo "virtual_domain.id for '$email' is '$domainid'"
 
}


if [ $1 == "u" ]; then

  if [ $2 == "list" ]; then
    query="select id, domain_id, email from virtual_users"
  fi

  if [ $2 == "add" ]; then
    email=$3
    getdomainid
    query="insert into virtual_users (domain_id, password, email) values('$domainid', ENCRYPT('$4', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), '$3');"
  fi

  if [ $2 == "delete" ]; then
    query="delete from virtual_users where email='$3';" 
  fi
fi

if [ $1 == "d" ]; then

  if [ $2 == "list" ]; then
    query="select * from virtual_domains"
  fi

  if [ $2 == "add" ]; then
    if [ ! -z $4 ]; then 
      query="insert into virtual_domains (name, id) values('$3', '$4');"
    else
      query="insert into virtual_domains (name) values('$3');"
    fi
  fi

  if [ $2 == "delete" ]; then
    query="delete from virtual_domains where name='$3';" 
  fi
fi


if [ $1 == "a" ]; then

  if [ $2 == "list" ]; then
    query="select * from virtual_aliases"
  fi

  if [ $2 == "add" ]; then
    email=$3
    getdomainid
    query="insert into virtual_aliases (domain_id, source, destination) values('$domainid', '$3', '$4');"
  fi

  if [ $2 == "delete" ]; then
    query="delete from virtual_aliases where source='$3';" 
  fi
fi


echo $query
mysql -p$mysqlpw "mailserver" -e "$query"
