+++
date = "2000-01-01T21:49:10+01:00"
draft = true
description = "Here are some of my tiny programs usually done at my leisure:"
keywords = ["rainbow", "isputil", "nls"]
title = "Tiny programs (pre 2000)"
type = "post"
+++



https://www.serverwatch.com/server-tutorials/using-a-physical-hard-drive-with-a-virtualbox-vm.html

VBoxManage internalcommands createrawvmdk -filename "sda.vmdk" -rawdisk /dev/sda

sudo chmod a+rw /dev/sda
sudo chmod a+rw sda.vmdk 


https://superuser.com/questions/1171524/possible-to-dual-boot-and-virtualize-same-physical-drive-containing-windows-10

setfacl -m u:mohsen:rw /dev/sda




vboxmanage modifyvm Win10 --hardwareuuid $(sudo dmidecode -s system-uuid)
