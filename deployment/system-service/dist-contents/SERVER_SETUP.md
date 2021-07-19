# Initial Server Setup
## Install Java

    sudo su -
    yum install java-11-openjdk
    sudo alternatives --config java
    # (select java 11)

## Create user rxnx.

    # sudo su -
    adduser rxnx --system -s /bin/false

## Setup application directory

    # sudo su -
    cp ~ad_app_<you>/rxnx-dist.tgz /usr/local 
    cd /usr/local
    tar xzvf rxnx-dist.tgz
    chown -R rxnx.rxnx rxnx/

Put in place an `application.properties` file next suitable for the environment,
in the `rxnx` directory (the same directory as the jar file). You can use the
`template-application.properties` as a guide. Make sure that the file is
readable by user `rxnx`.

The application should now be able to be started, as a trial run, via:

    # sudo -u rxnx bash
    java -jar rxnx.jar

## Systemd setup
Review rxnx.service to verify paths are correct for the host system, then copy
into the systemd system directory:

    # sudo su -
    cp rxnx.service /etc/systemd/system
    
    systemctl daemon-reload
    systemctl start rxnx
    # Start at boot time automatically.
    systemctl enable rxnx

Check status:

    systemctl status rxnx
