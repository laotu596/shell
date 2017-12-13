#!/bin/sh

#Folder="/dev/vda2"
function GetDiskSpc()
{
    if [ $# -ne 1 ]
     then
          return 1
     fi
#     Folder="$1$"
     DiskSpace=`df -lh |grep $Folder|awk '{print $5}'|awk -F% '{print $1}'`
     echo $DiskSpace
}

function GetListSpc()
{
    name=`ls -lh /var/log/message*`
    echo $name,"/n"
}
#GetListSpc;

Folder="/dev/vda2"
DiskSpace=`GetDiskSpc $Folder`
#echo "The system $Folder usage disk space is $DiskSpace%"
if [ $DiskSpace -gt 95 ]
then
{
#    echo "The usage of system disk($Folder) is larger than 90%"
    /bin/rm -rf /var/log/messages-*    
}
else
{
    echo "The usage of system disk($Folder) is normal"
}
fi
