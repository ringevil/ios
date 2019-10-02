/*
* Copyright (c) 2016, Nordic Semiconductor
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
* software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
* HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
* USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

extension Data {

    internal var hexString: String {
        return map { String(format: "%02X", $0) }.joined()
    }
    
    func read<R: FixedWidthInteger>(fromOffset offset: Int = 0) -> R {
        let length = MemoryLayout<R>.size
        
        return subdata(in: offset ..< offset + length).withUnsafeBytes { $0.load(as: R.self) }
    }
    
    func readSFloat(from offset: Int = 0) -> Float32 {
        let tempData: UInt16 = read(fromOffset: offset)
        var mantissa = Int16(tempData & 0x0FFF)
        var exponent = Int8(tempData >> 12)
        if exponent >= 0x0008 {
            exponent = -( (0x000F + 1) - exponent )
        }
        
        var output : Float32 = 0
        
        if mantissa >= ReservedSFloatValues.firstReservedValue.rawValue && mantissa <= ReservedSFloatValues.negativeInfinity.rawValue {
            output = Float32(Double.veservedValues[Int(mantissa - ReservedSFloatValues.firstReservedValue.rawValue)])
        } else {
            if mantissa > 0x0800 {
                mantissa = -((0x0FFF + 1) - mantissa)
            }
            let magnitude = pow(10.0, Double(exponent))
            output = Float32(mantissa) * Float32(magnitude)
        }
        
        return output
    }
    
    func readDate(from offset: Int = 0) -> Date {
        var offset = offset
        let year: UInt16 = read(fromOffset: offset); offset += 2
        let month: UInt8 = read(fromOffset: offset); offset += 1
        let day: UInt8 = read(fromOffset: offset); offset += 1
        let hour: UInt8 = read(fromOffset: offset); offset += 1
        let min: UInt8 = read(fromOffset: offset); offset += 1
        let sec: UInt8 = read(fromOffset: offset); offset += 1
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: .current,
                       year: Int(year),
                       month: Int(month),
                       day: Int(day),
                       hour: Int(hour),
                       minute: Int(min),
                       second: Int(sec))
        
        return calendar.date(from: dateComponents)!
    }
    
}
