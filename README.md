Waterstream Bridge Demo
=======================

This demo is based on [Waterstream Bridge Mode](https://docs.waterstream.io/release/bridge.html) feature and aims to show its capabilities and possible applications.

## Demo configuration

To enable Bridge Mode, we need to provide a `.config` file defining bridge parameters in HOCON format. Additionally, we need to specify the config file path in the environment variable `MQTT_BRIDGES_CONFIG_FILE`.

For this demo, Waterstream is provided as a Docker container, so variables and required volumes are configured in the `docker-compose.yml` file.

A valid Waterstream license file is also needed to run the demo.


### Enabling Bridge Mode

For this demo, we are connecting to [Lufthansa MQTT notification server](https://developer.lufthansa.com/docs/api_basics/notification_service/Connect_to_the_MQTT_Server).

The parameters for bridge connection should be configured in a file named `bridge.conf` (see `bridge.conf.sample` for reference).

**NOTE:** a valid `remoteClientId` (provided by Lufthansa) is needed to connect to notification server.


### SSL certificates

SSL certificates required for server connection must be placed into `ssl_cert/` directory.  

Lufthansa provides a SSL certificate by VeriSign, which was managed by Symantec; but Oracle has distrusted Symantec certificates starting from April 2019.

Connecting with this certificate causes this exception:

    sun.security.validator.ValidatorException: TLS Server certificate issued after 2019-04-16 and anchored by a distrusted legacy Symantec root CA: CN=VeriSign Class 3 Public Primary Certification Authority - G5, OU="(c) 2006 VeriSign, Inc. - For authorized use only", OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US

We can address this problem applying a workaround. Overriding the list of distrusted Certificate Authoirities defined in `java.security` file.

To achieve this we need to define a new property file (in this demo we called it `symantec.policy`), containing this:

    jdk.security.caDistrustPolicies=null

Then we need to load this configuration while starting Waterstream, using this JVM system property:

    -Djava.security.properties=/path/to/symantec.policy


## Starting the demo

To launch the demo, run the start script:

    ./startDemo.sh

This will provide default configs (at first run), create network and run the containers.

Similarly to stop the demo, you can run this script:

    ./stopDemo.sh


## Demo page

The actual demo consists in a web page embedding a Kibana dashboard with a graphical representation of the reached notification messages.

The page is defined in the file [`/demo-page/index.html`](https://gitlab.com/simplematter/waterstream-bridge-demo/-/blob/master/demo-page/index.html); the Kibana dasboard is embedded through an `iframe`.

When demo is run locally, the page is reachable at `http:localhost:8090`. In this case, the base url for the `iframe` showing the dashbourd should be set to: `http://localhost:5601/`.

When deployed to remote server, the base url for the dashboard `iframe` should be set according to the location of Kibana deployment on the server.

