# View Boston MySQL Replication

Reference: [https://www.digitalocean.com/community/tutorials/how-to-set-up-replication-in-mysql](https://www.digitalocean.com/community/tutorials/how-to-set-up-replication-in-mysql)
[https://devopscube.com/setup-mysql-master-slave-replication/](https://devopscube.com/setup-mysql-master-slave-replication/)

For ansible to run SQL queries, make sure PyMySQL is install

    pip install pymysql


## Configuration

### Ansible user

Create the user in both database using phpMyAdmin:

    CREATE USER 'ansible'@'%' IDENTIFIED BY 'oLT01$th83e14o()B5XS)5%9';
    GRANT ALL PRIVILEGES ON *.* TO 'ansible'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;

### Mysql setup

After running the `playbooks-mysql-replication.yml` playbook to setup the MySQL configuration, check the Master status.

From the MySQL prompt, Check the master status. Note down the file [mysql-bin.000001] and Position[706] parameters from the output. It is required for the slave replication configuration.

#### On the master:

On the master, flush and lock all tables by running FLUSH TABLES WITH READ LOCK. Keep this session running - exiting it will release the lock.


    SHOW MASTER STATUS\G

#### On the slave:

    Stop the slave threads using the following command.

    STOP SLAVE;

Replace MASTER_LOG_FILE & MASTER_LOG_POS with the values, you got from the previous in master configuration.

    CHANGE MASTER TO MASTER_HOST='192.168.10.24',MASTER_USER='replica_user', MASTER_PASSWORD='nZojZwCRAJj8q3VfQV6kFPxdRp6mTjJ6rxgEnG9tVxszreT6', MASTER_LOG_FILE='mysql-bin.000458', MASTER_LOG_POS= 23554;

Now, start the slave threads.

    START SLAVE;

Check the MySQL replication slave status.

    SHOW SLAVE STATUS\G


When replication is complete:

On the master:

    UNLOCK TABLES;


## Notes

CREATE USER 'replica_user'@'%' IDENTIFIED BY 'nZojZwCRAJj8q3VfQV6kFPxdRp6mTjJ6rxgEnG9tVxszreT6';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
FLUSH privileges;

ROOT PASS SLAVE: 