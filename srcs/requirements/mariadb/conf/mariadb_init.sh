#!/bin/ash

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi

./mariadb_conf.sh

if [ ! -d "${db_path}" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

#if [ ! -d "/var/lib/mysql/wordpress" ]; then
if [ ! -d "${wp_db_path}" ]; then
        cat << EOF > /tmp/mariadb_init.sql
CREATE DATABASE IF NOT EXISTS \`${db_name}\`;
FLUSH PRIVILEGES;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/mariadb_init.sql
fi

#CREATE USER IF NOT EXISTS \`${db_user}\`@'%' IDENTIFIED BY '${wp_password}';
#GRANT ALL PRIVILEGES ON ${db_name}.* TO \`${db_user}\`@'%' IDENTIFIED BY '${wp_password}';
: <<'END_COMMENT'
+ /usr/bin/mysqld '--user=mysql' --bootstrap
2025-03-26 16:38:07 0 [Note] Starting MariaDB 10.11.11-MariaDB source revision e69f8cae1a15e15b9e4f5e0f8497e1f17bdc81a4 server_uid oKy6kXSLEtVIoBcZkHc1ctEC1iw= as process 62
2025-03-26 16:38:07 0 [Note] InnoDB: Compressed tables use zlib 1.3.1
2025-03-26 16:38:07 0 [Note] InnoDB: Number of transaction pools: 1
2025-03-26 16:38:07 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
2025-03-26 16:38:07 0 [Note] InnoDB: Using Linux native AIO
2025-03-26 16:38:07 0 [Note] InnoDB: Initializing buffer pool, total size = 128.000MiB, chunk size = 2.000MiB
2025-03-26 16:38:07 0 [Note] InnoDB: Completed initialization of buffer pool
2025-03-26 16:38:07 0 [Note] InnoDB: Buffered log writes (block size=512 bytes)
2025-03-26 16:38:07 0 [Note] InnoDB: End of log at LSN=45502
2025-03-26 16:38:07 0 [Note] InnoDB: 128 rollback segments are active.
2025-03-26 16:38:07 0 [Note] InnoDB: Setting file './ibtmp1' size to 12.000MiB. Physically writing the file full; Please wait ...
2025-03-26 16:38:07 0 [Note] InnoDB: File './ibtmp1' size is now 12.000MiB.
2025-03-26 16:38:07 0 [Note] InnoDB: log sequence number 45502; transaction id 14
2025-03-26 16:38:07 0 [Note] Plugin 'FEEDBACK' is disabled.
2025-03-26 16:38:07 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
ERROR: 1290  The MariaDB server is running with the --skip-grant-tables option so it cannot execute this statement
2025-03-26 16:38:07 0 [ERROR] Aborting
END_COMMENT
exec "$@"

# HEALTHCHECK
