def postgres_encoding_cmds
  stub_command("psql -c 'SELECT encoding FROM pg_database;' | grep -q template0").and_return(true)
  stub_command("psql -c 'SELECT encoding FROM pg_database;' | grep -q template1").and_return(true)
  stub_command("psql -c 'SELECT encoding FROM pg_database;' | grep -q postgres").and_return(true)
end

def mysql_uniqueid_db
  stub_command("/usr/bin/mysql -e 'show databases;' | grep -q pacifica_uniqueid").and_return(true)
  stub_command("/usr/bin/mysql -e 'select User from mysql.user;' | grep uniqueid").and_return(true)
end

def mysql_ingest_db
  stub_command("/usr/bin/mysql -e 'show databases;' | grep -q pacifica_ingest").and_return(true)
  stub_command("/usr/bin/mysql -e 'select User from mysql.user;' | grep ingest").and_return(true)
end

def mysql_cart_db
  stub_command("/usr/bin/mysql -e 'show databases;' | grep -q pacifica_cart").and_return(true)
  stub_command("/usr/bin/mysql -e 'select User from mysql.user;' | grep -q cartd").and_return(true)
end

def postgres_metadata_db
  stub_command("psql -c '\\l' | grep -q pacifica_metadata").and_return(true)
  stub_command("psql -c 'SELECT rolname FROM pg_roles;' | grep -q pacifica").and_return(true)
  stub_command("psql -c '\\l' | grep -q pacifica=").and_return(true)
  stub_command('curl localhost:8121/users | grep -q dmlb2001').and_return(true)
end
