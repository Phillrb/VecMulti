//
//  main.swift
//  VecMultiDev
//
//  Created by Phillip Riscombe Burton on 30/01/2020.
//  Copyright © 2020 Phill. All rights reserved.
//

import Foundation

// VecMulti Dev Mode
// Transfer a binary to the Vectrex


// VecMulti significant chars:
// Mark the start of data being sent
let startData = Data.init(repeating: Character.init("s").asciiValue!, count: 1)
// Mark the next byte of data
let markerData = Data.init(repeating: Character.init("@").asciiValue!, count: 1)
// Mark the start of data being sent
let endData = Data.init(repeating: Character.init("y").asciiValue!, count: 1)


print("Welcome to VecMulti!");

// Save paths to the binary file and / or the serial port
var filePath : String? = nil
var portPath : String? = nil
for argStr in CommandLine.arguments {
    if argStr.hasSuffix(".BIN") || argStr.hasSuffix(".bin") {
        filePath = argStr
    } else if(!argStr.hasSuffix("VecMultiDev")){
        portPath = argStr
    }
}

// Get Binary file data
if filePath == nil {
    print("Enter path to binary: ");
    filePath = readLine()
}
let file: FileHandle? = FileHandle(forReadingAtPath: filePath!)

// Read in the data from binary file
var data: Data? = nil
if file != nil {
    data = file?.readDataToEndOfFile()
    file?.closeFile()
}
else {
    print("Error getting data from: " + filePath!)
    exit(1)
}


// Get access to serial port
if portPath == nil {
    
    // List all ports for user to choose
    let ports = ORSSerialPortManager.shared().availablePorts
    var pos = 1
    for sPort in ports {
        print("Port \(pos): " + sPort.path)
        pos+=1
    }
    
    print("Select serial port: ");
    let portNo = readLine()
    portPath = ports[Int(portNo ?? "0")! - 1].path
}
print("SERIAL PORT: " + portPath!)

// Setup serial port
let serialPort = ORSSerialPort(path:portPath!)
serialPort?.baudRate = 115200
serialPort?.numberOfDataBits = 8;
serialPort?.parity = .none
serialPort?.numberOfStopBits = 1

usleep(100000)

print("Opening serial port");
serialPort?.open()

usleep(100000)

print("Sending start char");
// Start char - inform Vectrex that we're about to give it data
serialPort?.send(startData)

usleep(1000000)

print("Transferring bin file... please wait...");
var currentDat: Data? = nil

// Start sending data over
for binByte in (data?.enumerated())! {

    // Prepend byte with '@'
    serialPort?.send(markerData)
    usleep(200)

    // Send byte
    currentDat = Data.init(repeating: binByte.element, count: 1)
    serialPort?.send(currentDat!)
    
    usleep(200)
}

print("Sending end char...");
serialPort?.send(endData)
print("Closing port...");
serialPort?.close()
print("Done");
