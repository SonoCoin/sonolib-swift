//
//  Num+Ext.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

enum Endianness {
    case big
    case little
}

extension UInt32 {
    
    var bdata: Data {
        var u32 = self.bigEndian
        return Data(buffer: UnsafeBufferPointer(start: &u32, count: 1))
    }
    
    var ldata: Data {
        var u32 = self.littleEndian
        return Data(buffer: UnsafeBufferPointer(start: &u32, count: 1))
    }
    
}

extension UInt64 {

    var bdata: Data {
        var u64 = self.bigEndian
        return Data(buffer: UnsafeBufferPointer(start: &u64, count: 1))
    }

    var ldata: Data {
        var u64 = self.littleEndian
        return Data(buffer: UnsafeBufferPointer(start: &u64, count: 1))
    }
    
}

extension Data {
    
    var bint16: Int16 {
        return Int16(bigEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    var buint32: UInt32 {
        return UInt32(bigEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    var buint64: UInt64 {
        return UInt64(bigEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    var lint16: Int16 {
        return Int16(littleEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    var luint32: UInt32 {
        return UInt32(littleEndian: self.withUnsafeBytes { $0.pointee })
    }
    
    var luint64: UInt64 {
        return UInt64(littleEndian: self.withUnsafeBytes { $0.pointee })
    }
    
}
