//
//  ControlFlags.swift
//  Termios
//
//  Created by Neil Pankey on 3/20/15.
//  Copyright (c) 2019 Jacob Williams & Neil Pankey. All rights reserved.
//

#if os(macOS)
import Darwin
#else
import Glibc
#endif

/// Control flag values in a `termios` structure.
public struct ControlFlags: OptionSet {
    public var rawValue: UInt32

    private init(_ value: Int32) {
        self.init(rawValue: UInt32(value))
    }

    init(_ value: UInt32) {
        rawValue = value
    }

    public init(rawValue value: UInt32) {
        rawValue = value
    }

    public static let zero: ControlFlags = {
        return .init(rawValue: 0)
    }()

    /// Character size mask. Values are s5, s6, s7, or s8.
    public static let size = ControlFlags(CSIZE)
    /// Character size mask.
    public static let s5 = ControlFlags(CS5)
    /// Character size mask.
    public static let s6 = ControlFlags(CS6)
    /// Character size mask.
    public static let s7 = ControlFlags(CS7)
    /// Character size mask.
    public static let s8 = ControlFlags(CS8)

    /// Set two stop bitsm rather than one.
    public static let stopBits = ControlFlags(CSTOPB)

    /// Enable receiver.
    public static let read = ControlFlags(CREAD)

    /// Enable parity generation on output and parity checking for input.
    public static let parity = ControlFlags(PARENB)

    /// If set, then parity for input and output is odd; otherwise even parity is used.
    public static let oddParity = ControlFlags(PARODD)

    /// Lower modem control lines after last process closes the device (hang up).
    public static let hangUp = ControlFlags(HUPCL)

    /// Ignore modem control lines.
    public static let local = ControlFlags(CLOCAL)
}
