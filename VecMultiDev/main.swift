//
//  main.swift
//  VecMultiDev
//
// SPDX-short-identifier: BSD-3-Clause
// Copyright 2020 Phillip Riscombe-Burton
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
