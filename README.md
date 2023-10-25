# RASPBERRY PI as Home IOT

This project is a result of setting up a Raspberry pi 4 as a device that can be utilized as shared home device.
The point of this project was to get to know better the linux eco-system and increase knowladge about remote device menagement.

Project contains several bash files, that might make it easier to set up the PI, such as
remote printing within a local network, add support for Corsair Gaming Glaive RGB mouse, and access
 to locally stored notes.

## Remote priniting

With the use of [CUPS](https://www.cups.org/), that allows connection to printers, even if the device doesn't
have wifi or bluetooth chip. Additionally, the [foo2zjs](https://packages.debian.org/pl/sid/text/printer-driver-foo2zjs) project,
allows a use of printer Samsung CLX-3185. I have used a open source driver created for CLX-3180, but the machines are very similar.
It takes some time, to get the printer running, after the communication is established, but it gets the proper result in the end.

To allow a connection and printing capabilities within Windows machines you still need to install Windows driver for
your printers. Then you can use [Samba](https://www.samba.org/) to connect with Raspberry Pi. Samba allows connection
between linux (raspi) and Windows (home machines) by adding additional layer of communication. With 3 of those packages,
you can make your old Samsung printer to be accessable within a wifi range to print anything you need.

## Mouse support

Linux kernel doesn't support any Corsair mouses, that has rgb customizable settings. I am using a open source project
[ckb-next](https://github.com/ckb-next/ckb-next) to build a driver myself. It is important to note, that mouse WILL NOT work, 
if the driver is not installed. It is not necessary to have it on Raspi, because now I am connecting to it via
[SSH](https://datatracker.ietf.org/doc/html/rfc4250), but it came in handy, when I started using the device with a desktop enviroment. 

## Syncthing

[Syncthing](https://syncthing.net/) is a amazing project, that enables shared files not only in local network, but also in World Wide Web.
I am using this tool to share files and have it synced with local devices. This way I dont need to git commit my notes,
every time I make a small change in a folder.