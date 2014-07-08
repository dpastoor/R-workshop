#!/bin/bash
# script to be run on master node after rstudio servers are created. This makes 
# their webservers available from the internet

source 
KEYPAIR_NAME=akw_key
NECTAR_IMAGE_ID='f30385d3-a7b0-44dd-9e4f-906042694155'
NUMBER_OF_VMS=30
FLAVOR_SIZE=1
./instantiate_vms.sh   -i "${NECTAR_IMAGE_ID}"   -k "${KEYPAIR_NAME}"   -n 1   -s "${FLAVOR_SIZE}" -u ./postinstall.sh

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


## push a required R package to each node and install it
# get a list of nodes:
nova list | grep rVM-akw- | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | awk '{print $0 " ubuntu"}' > hosts.txt
# copy the package
parallel-scp -h hosts.txt -OStrictHostKeyChecking=no ASMap_akw.tar.gz /home/ubuntu/ASMap_akw.tar.gz

# copy the Rscript
parallel-scp -h hosts.txt -OStrictHostKeyChecking=no install_ASMap_package.Rscript /home/ubuntu/install_ASMap_package.Rscript

# run the script
parallel-ssh -h hosts.txt -OStrictHostKeyChecking=no -OHashKnownHosts=no chmod +x /home/ubuntu/install_ASMap_package.Rscript
parallel-ssh -h hosts.txt -OStrictHostKeyChecking=no -OHashKnownHosts=no /home/ubuntu/install_ASMap_package.Rscript

# useful
nova list



## put this in ~/install_ASMap_package.Rscript ont he master-api
#!/usr/bin/Rscript
install.packages(pkgs=c("qtl","gtools","fields"), dependencies=TRUE, repos="http://mirror.aarnet.edu.au/pub/CRAN/", lib="~")
install.packages("~/ASMap_akw.tar.gz", lib="~")
