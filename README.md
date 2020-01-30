# VecMulti
Send Vectrex game binary images to VecMulti from the macOS command line

* Plug in VecMulti without microSD card
* Attach 4 pin header on VecMulti as follows:
** Pin 1 (GND) connect to GND on USB-serial adapter. This pin is closest to the edge of the cart.
** Pin 2 (RX) connect to TX on USB-serial adapter.
** Pin 3 (TX) connect to RX on USB-serial adapter.
** Pin 4 (VCC) this is unconnected.
* Connect USB-serial adapter to Mac
* Turn on Vectrex
* Wait for 'Dev Mode'
* Launch 'VecMultiDev' in Terminal and optionally supply port and path to game binary as unnamed arguments (or interact with command line program when run to supply these details).
* Binary file will upload
* Game will start automatically after upload

Similar to https://github.com/nanoflite/vecmulti but without the Python dependency (or the ability to make menus).
Uses https://github.com/armadsen/ORSSerialPort with thanks!
