# sufia
Sufia 6.x vagrant box

Based off of Fedora 4 Vagrant Virtual Machine. Please see https://github.com/fcrepo4-exts/fcrepo4-vagrant

## Requirements

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

## Usage

1. `git clone https://github.com/seanlw/sufia-vagrant.git`
2. `cd sufia-vagrant`
3. `vagrant up`

You can shell into the machine with `vagrant ssh` or `ssh -p 2222 vagrant@localhost`

## Environment

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](http://tomcat.apache.org) at [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.x](http://fedora.info/about) at [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](http://lucene.apache.org/solr/) at [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in "/var/lib/tomcat7/solr"
  * [Fuseki 2.3.0](http://jena.apache.org/documentation/fuseki2/) at [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in "/etc/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/etc/fuseki/databases/test\_data"
  * [Fcrepo-camel-toolbox 4.x](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox)
    * Installed in Tomcat container
  * [Sufia 6.x](https://github.com/projecthydra/sufia/tree/6.x-stable) at [http://localhost:3000](http://localhost:3000)

###Usage

* Install Vagrant and VirtualBox
* Clone this repository 
* `cd sufia-vagrant`
* (optional) to enable role-based access control, edit `install_scripts/config` and change the `FEDORA_AUTH` variable to true.
  This will enable three accounts:
  * user account `testuser`, with password `password1`
  * user account `adminuser`, with password `password2`
  * admin account `fedoraAdmin` with the password `secret3`
* (optional) to enable fedora internal audit capability, edit `install_scripts/config` and change the FEDORA_AUDIT variable to true. The FEDORA_AUDIT_LOCATION can also be changed from its default "/audit", if necessary.
* `vagrant up`

## Support

If you receive the following error:
```
There are errors in the configuration of this machine, Please fix the following errors and try again:

vm:
* The box 'ubuntu/trusty64' could not be found.
```

Edit the file **Vagrantfile**, find the lines:
```
# Below needed for Vagrant versions < 1.6.x
# config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
```
and un-comment the **config.vm.box\_url** line, save the file and retry.

#### Port 9080 (reindexing service) unavailable after vagrant up

It might happen that during the first `vagrant up` the reindexing service is not installed and the port 9080 is inaccessible (try `telnet localhost 9080`). To fix this run `vagrant provision` and check again. If it still does not work, install the services manually:
```
vagrant ssh
cd /opt/karaf/bin
./client </vagrant/install_scripts/fedora_camel_toolbox.script
```

## Windows Troubleshooting

If you receive errors involving `\r` (end of line):

Edit the global `.gitconfig` file, find the line:
```
autocrlf = true
```
and change it to
```
autocrlf = false
```
Remove and clone again. This will prevent windows git clients from automatically replacing unix line endings LF with windows line endings CRLF.

## Maintainers

Current maintainers:

* [Nick Ruest](https://github.com/ruebot)
* [Jared Whiklo](https://github.com/whikloj)
* [Sean Watkins](https://github.com/seanlw)

## Thanks

This VM setup was heavily influenced (read: stolen) from [Fedora 4 VM](https://github.com/fcrepo4-exts/fcrepo4-vagrant).
Fedora 4 VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install).
