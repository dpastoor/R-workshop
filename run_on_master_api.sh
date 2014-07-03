#!/bin/bash
# script to be run on master node after rstudio servers are created. This makes 
# their webservers available from the internet

source 
KEYPAIR_NAME=akw_keypair

nova secgroup-create r_serv "RStudio server"
# note that the CIDR (last param) restricts logins to (mostly) Uni of Adl IP addresses
nova secgroup-add-rule r_serv tcp 80 80 129.127.183.0/24
# get a list of server IDs
servers=`nova list | grep rVM-akw-[0-9] | cut -f2 -d" "`

for this_serv in $servers; do
   nova add-secgroup ${this_serv} r_serv
done

for this_serv in $servers; do
   nova delete ${this_serv}
done



# useful
nova list

