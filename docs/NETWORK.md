# Network

## Connect WIFI using command line

You can connect to the internet using command line ```nmcli``` if you do not install any graphical way to do this

```shell
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect wifiname password wifipassword
```