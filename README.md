# eth.sh
## Ubuntu 16.04 LTS Ethereum + ethminer setup script for Nvidia GPUs

### New in version 1.1
-script now activates auto-login with immediate screensaver lock. This facilitates automated miner startup
 as long as computer has power and secure unattended reboots. 
-if -w <wallet_address> option is used upon install miner will automatically launch upon startup behind locked
 screensaver at any reboot, powerup. [ request from user krtschmr ]
-fixed bug parsing multiple GPU indexes [ thanks to user teflon16 for finding this bug ]
-special thanks to user luigi311 for code suggestions, team is working on integrating suggestions. 

- Written for Ubuntu 16.04 with a Desktop environment (Typical default install)
- Features automatic power reduction and overclocking of GTX 1060 and GTX 1070 GPUs
- Installs Nvidia driver if needed
- Configures nvidia cool-bits xorg config as needed for overclocking
- Installs latest ethminer with CUDA optimizations 
- Installs Ethereum package including geth
- Optionally installs CUDA 8.0 toolkit and sets correct PATH per Nvidia documentation
- Overclocking only option
- Now fully automated
- Will optionally donate 60 minutes of GPU time after install, only runs once

## USAGE

Typical usage for full automation. From Desktop open terminal and `cd` to directory with script. Your computer will restart and continue automatically as needed.

`sudo ./eth.sh -w 0xf1d9bb42932a0e770949ce6637a0d35e460816b5`

Options can be added as desired. For verbose mode (lots of output):

`sudo ./eth.sh -v`

To reduce GPU power and overclock with installing anything: (may require reboot if cool-bits are not set)

`sudo ./eth.sh -o`

Other options include:

```-v       enable verbose mode, lots of output
-c       install CUDA 8.0 toolkit, not required for ethminer
-w       wallet address - this will activate full automation mode
-h       print this menu
-375     installs Nvidia 375 driver version rather than 375 
-o       overclocking only
```
After initial run the script will be installed to your PATH and can be called from anywhere to run overclocking:

```
sudo eth.sh -o
found 1 gpu[s]...
found GeForce GTX 1060 at index 0...
setting persistence mode...
Enabled persistence mode for GPU 0000:01:00.0.
All done.
setting power limit to 75 watts..
Power limit for GPU 0000:01:00.0 was set to 75.00 W from 120.00 W.
All done.
setting memory overclock of 500 Mhz...

  Attribute 'GPUMemoryTransferRateOffset' (riker-Z:0[gpu:0]) assigned value
  500.
  ```
  
















