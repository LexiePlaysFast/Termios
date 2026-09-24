//
//  Termios.swift
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
import ErrNo

/// Swift wrapper around the raw C `termios` structure.
public struct Termios {
    // MARK: Constructors

    /// Constructs a `Termios` structure from a given file descriptor `fd`.
    public static func fetch(fd: Int32) throws -> Termios {
        var raw = termios()
        guard tcgetattr(fd, &raw) == 0 else {
            throw ErrNo.lastError
        }

        var windowSize = winsize()
        guard ioctl(fd, UInt(TIOCGWINSZ), &windowSize) == 0 else {
            throw ErrNo.lastError
        }

        return Termios(raw: raw, windowSize: windowSize)
    }

    // MARK: Properties

    /// Input flags
    public var inputFlags: InputFlags {
        get { return InputFlags(UInt32(raw.c_iflag)) }
        set { raw.c_iflag = UInt(newValue.rawValue) }
    }

    /// Output flags
    public var outputFlags: OutputFlags {
        get { return OutputFlags(UInt32(raw.c_oflag)) }
        set { raw.c_oflag = UInt(newValue.rawValue) }
    }

    /// Control flags
    public var controlFlags: ControlFlags {
        get { return ControlFlags(UInt32(raw.c_cflag)) }
        set { raw.c_cflag = UInt(newValue.rawValue) }
    }

    /// Local flags
    public var localFlags: LocalFlags {
        get { return LocalFlags(UInt32(raw.c_lflag)) }
        set { raw.c_lflag = UInt(newValue.rawValue) }
    }

    /// Input speed
    public var inputSpeed: UInt {
        return UInt(raw.c_ispeed)
    }

    /// Output speed
    public var outputSpeed: UInt {
        return UInt(raw.c_ispeed)
    }

    /// Terminal size
    public var size: (rows: Int, columns: Int) {
        return (rows: Int(windowSize.ws_row), columns: Int(windowSize.ws_col))
    }

    // MARK: Operations

    /// Updates the file descriptor's `Termios` structure.
    public func update(fd: Int32) throws {
      try withUnsafePointer(to: raw) { raw in
        guard tcsetattr(fd, TCSANOW, raw) == 0 else {
            throw ErrNo.lastError
        }
      }
    }

    /// Update terminal size
    public mutating func readWinch(fd: Int32) throws {
        guard ioctl(fd, UInt(TIOCGWINSZ), &windowSize) == 0 else {
            throw ErrNo.lastError
        }
    }

    // MARK: Private

    /// Wraps the `termios` structure.
    private init(raw: termios, windowSize: winsize) {
        self.raw = raw
        self.windowSize = windowSize
    }

    /// The wrapped termios struct.
    private var raw: termios
    private var windowSize: winsize
}
