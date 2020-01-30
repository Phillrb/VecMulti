# VecMulti uploader for macOS
Send Vectrex game binary images over USB to Serial to VecMulti from the macOS command line.

Download the latest release from <https://github.com/Phillrb/VecMulti/releases/latest>

No need to compile; just run it!

## About VecMulti 
The VecMulti is a Vectrex multicart and dev platform created by Richard Hutchinson on AtariAge forums:
<https://www.reddit.com/r/Vectrex/comments/eotqj2/vecmulti_production_resumed_vectrex_micro_sd_card/>


## Uploader Details
Supports USB-to-Serial adapters that include CP2104 USB to UART etc

![Alt text](/resources/vecmulti_dev_mode.jpg "Connect to VecMulti")

## Upload Steps
* Plug in VecMulti without microSD card
* Attach 4 pin header on VecMulti as follows:
  * Pin 1 (GND) connect to GND on USB-serial adapter. This pin is closest to the edge of the cart.
  * Pin 2 (RX) connect to TX on USB-serial adapter.
  * Pin 3 (TX) connect to RX on USB-serial adapter.
  * Pin 4 (VCC) this is unconnected.
* Connect USB-serial adapter to Mac
* Turn on Vectrex
* Wait for 'Dev Mode'


![Alt text](/resources/dev_mode.jpg "Dev Mode")

* Launch 'VecMultiDev' in Terminal and optionally supply port and path to game binary as unnamed arguments (or interact with command line program when run to supply these details).
* Binary file will upload
* Game will start automatically after upload


Similar to <https://github.com/nanoflite/vecmulti> but without the Python dependency (or the ability to make menus).

Uses <https://github.com/armadsen/ORSSerialPort> with thanks!
