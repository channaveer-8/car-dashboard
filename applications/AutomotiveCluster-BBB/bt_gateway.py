#!/usr/bin/env python3
import socket
import sys
import time
import os
import termios

SERIAL_PORT = "/dev/ttyS1"
SOCKET_PATH = "/home/debian/dashboard.sock"

def init_serial(port):
    try:
        # Open serial port in read-only, non-controlling tty mode
        fd = os.open(port, os.O_RDONLY | os.O_NOCTTY)
        
        # Configure terminal attributes for 9600 baud, raw 8N1 mode
        attrs = termios.tcgetattr(fd)
        
        # Set baud rate to 9600
        attrs[4] = termios.B9600 # input speed
        attrs[5] = termios.B9600 # output speed
        
        # Control Modes: 8-bit, ignore modem controls, enable receiver
        attrs[2] = (attrs[2] & ~termios.CSIZE) | termios.CS8
        attrs[2] |= (termios.CLOCAL | termios.CREAD)
        attrs[2] &= ~(termios.PARENB | termios.PARODD | termios.CSTOPB | termios.CRTSCTS)
        
        # Local Modes: Disable echo, canonical (line-by-line), signals
        attrs[3] &= ~(termios.ICANON | termios.ECHO | termios.ECHOE | termios.ISIG)
        
        # Input Modes: Disable software flow control, ignore break conditions
        attrs[0] &= ~(termios.IXON | termios.IXOFF | termios.IXANY | termios.IGNBRK)
        
        # Output Modes: Raw output
        attrs[1] &= ~termios.OPOST
        
        # Set VMIN/VTIME (block until at least 1 character is read)
        attrs[6][termios.VMIN] = 1
        attrs[6][termios.VTIME] = 0
        
        termios.tcsetattr(fd, termios.TCSANOW, attrs)
        return fd
    except Exception as e:
        print(f"Error opening serial port {port}: {e}")
        return -1

def main():
    print(f"Starting Python Serial-to-Socket Gateway on {SERIAL_PORT} (Standard Library Mode)...")
    
    serial_fd = init_serial(SERIAL_PORT)
    if serial_fd < 0:
        sys.exit(1)
        
    sock = None
    line_buffer = bytearray()
    
    while True:
        # Connect to Unix Socket
        if sock is None:
            try:
                sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                sock.connect(SOCKET_PATH)
                print(f"Connected to socket {SOCKET_PATH}")
            except Exception as e:
                sock = None
                time.sleep(2)
                continue
                
        # Read Serial and Forward to Socket
        try:
            # Read character by character from the file descriptor
            char_bytes = os.read(serial_fd, 1)
            if not char_bytes:
                time.sleep(0.01)
                continue
                
            c = char_bytes[0]
            if c == ord('\n') or c == ord('\r'):
                if len(line_buffer) > 0:
                    line_buffer.append(ord('\n'))
                    # Forward line to UNIX socket
                    sock.sendall(line_buffer)
                    line_buffer = bytearray()
            else:
                # Buffer limit safety
                if len(line_buffer) < 256:
                    line_buffer.append(c)
                else:
                    line_buffer = bytearray()
        except (socket.error, BrokenPipeError):
            print("Socket disconnected. Retrying connection...")
            sock.close()
            sock = None
        except Exception as e:
            print(f"Error: {e}")
            time.sleep(1)

if __name__ == "__main__":
    main()
