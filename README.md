# Webcam Control Script

This is a simple script to control webcams on Linux. This script allows you to
check the status, turn off, turn on, or toggle a webcam. This is intended for
showing the status of the webcam in things like polybar and being able to add a
key-bind to turn off and on the webcam.

This script can actually do this for most USB connected devices and not just
webcams but I personally can't think of a USB device you want to control
dynamically.

NOTE: If the purpose of turning off an turning on the webcam is privacy and
security against malware, then this is not a good script. I would recommend
using a physical block/cover to achieve this.

## Installation

This script needs root privileges to run. It is important to verify that the
script does not do anything bad before giving it these permissions. I do not
intend to cause malicious harm, however, I cannot guarantee the security of the
script. I use it and it works for me.

The simple way to install the script is to run:

```bash
bash install.sh
```

However, I really insist that you read the script and understand what it's
doing. 

1. The install script copies the python script to the `/usr/bin` directory.
2. The install script marks the python script as executable.
3. The install script add a line to the "sudoers file" to allow the script to be
   run as root without having to provide a password. This is done to allow an
   easy way to add key-binds.

NOTE: If you change the `DESTINATION_FILE` in the `install.sh` script and you
want to uninstall the script then make sure to change the `DESTINATION_FILE` in
the `uninstall.sh` file too.

## Usage

If you added the required line to the sudoers file then you can run the script
with sudo privileges without a password.

### Help

To find the help message just run:

```bash
webcam-control --help
```

### Identify Webcam Device

Find your webcam in the list of devices provided by:

```bash
webcam-control devices
```

You can also use the `lsusb` command for more information about the devices
connected to the computer. Then you can cross-reference the name with the names
output by the above command.

Let's say that your webcam is called "Sony Video HD"

### Run Action on Webcam 

#### Check Status

You can check the status of the webcam in the following way:

```bash
sudo webcam-control status --webcams "Sony Video HD"
```

Or if you want a shorter command:

```bash
sudo webcam-control status -w "Sony Video HD" 
```

You can provide multiple webcams when performing actions by just separating them
by a space:

```bash
sudo webcam-control status -w "Sony Video HD" "Webcam 2"
```

#### Toggle, On, Off

You can toggle, turn on, or turn off webcams in the following way:

```bash
sudo webcam-control on -w "Sony Video HD"
sudo webcam-control off -w "Sony Video HD"
sudo webcam-control toggle -w "Sony Video HD"
```

#### Continuous Status

If you want to constantly poll the status of the webcam (useful for things like
polybar), then you can use the `--continuous` flag.

```bash
# This defaults to an output every second with either "On" or "Off"
sudo webcam-control status --webcams "Sony Video HD" --continuous

# For something shorter
sudo webcam-control status -w "Sony Video HD" -c
```

You can control the interval for the update with `--interval`  or `-i`, you can
control the message for `on` and `off` with `--on` and `--off`.

Example:

```bash
# A simple example
sudo webcam-control status -w "Sony Video HD" -c -i 2 --on "Cam on" --off "Cam off"

# The command I use with polybar
sudo webcam-control status -w "Sony Video HD" -c --on "󰄀" --off "󰗟"
```

## Contribute

If you find bugs or have ideas on how the script can be made better, please feel
free to send me a message or create a pull request.

## Acknowledgements

This script was inspired by this post on reddit by `u/patri9ck` and `u/guildem`:
[reddit post](https://www.reddit.com/r/archlinux/comments/mfp0ve/command_line_utility_for_managing_my_webcam/).
