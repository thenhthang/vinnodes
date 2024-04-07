#### Thay doi timezone
```
sudo timedatectl set-timezone UTC
```
#### Giai nen
```
tar -xzvf file-name.tar
```
#### Di chuyen file
```
mv path/tenfile.abc path/tenfilemoi.abc
```
#### Copy file
```
cp path/tenfile.abc path/tenfilemoi.abc
```
#### Kiem tra chuong trinh dang su dung port nao
```
 netstat -anp|grep programname
```
#### Kiem tra port dang su dung boi chuong trinh nao
```
netstat -anp|grep portnumber
```
### Liet ke tat ca cac file va thu muc kem kich thuoc
```
du -h --max-depth=1 --block-size=1M .*
```
#### Xuat thong tin port dang duoc su dung
```
sudo netstat -tulpn | grep LISTEN
```
#### Cac lenh xu ly file
```
To copy all from Local Location to Remote Location (Upload)

scp -r /path/from/local username@hostname:/path/to/remote
To copy all from Remote Location to Local Location (Download)

scp -r username@hostname:/path/from/remote /path/to/local
Custom Port where xxxx is custom port number

 scp -r -P xxxx username@hostname:/path/from/remote /path/to/local
Copy on current directory from Remote to Local

scp -r username@hostname:/path/from/remote .
Help:

-r Recursively copy all directories and files
Always use full location from /, Get full location/path by pwd
scp will replace all existing files
hostname will be hostname or IP address
if custom port is needed (besides port 22) use -P PortNumber
. (dot) - it means current working directory, So download/copy from server and paste here only.
Note: Sometimes the custom port will not work due to the port not being allowed in the firewall, so make sure that custom port is allowed in the firewall for incoming and outgoing connection
```
