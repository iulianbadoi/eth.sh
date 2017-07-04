# eth.sh
## Ubuntu 16.04 LTS Ethereum + ethminer setup script for Nvidia GPUs

- Written for Ubuntu 16.04 with a Desktop environment (Typical default install)
- Features automatic power reduction and overclocking of GTX 1060 and GTX 1070 GPUs
- Installs Nvidia driver if needed
- Installs latest ethminer with CUDA optimizations 
- Installs Ethereum package including geth
- Optionally installs CUDA 8.0 toolkit and sets correct PATH per Nvidia documentation
- Overclocking only option
- Now fully automated
- Will optionally donate 60 minutes of GPU time after install, only runs once

## USAGE

Typical usage (no options). From Desktop open terminal and `cd` to directory with script. Your computer will restart and continue automatically as needed.

`sudo ./eth.sh`

Options can be added as desired. For verbose mode (lots of output):

`sudo ./eth.sh -v`

To reduce GPU power and overclock with installing anything:

`sudo ./eth.sh -o`

Other options include:

```-v       enable verbose mode, lots of output
-c       install CUDA 8.0 toolkit, not required for ethminer
-h       print this menu
-381     installs Nvidia 381 driver instead of Long Lived 375
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
  
















