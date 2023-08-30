set history save on
set history size 1000
#set history filename gdbhistory.txt
set remote exec-file /home/root/fsstress
#target extended-remote 10.0.0.2:10000
target extended-remote 127.0.0.1:10000
set sysroot target:/
file fsstress
b main
#handle SIGUSR1 nostop noprint

#run --gtest_filter=RTCTest.Write
