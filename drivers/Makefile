CC=arm-none-linux-gnueabihf-gcc
TARGET=test_gpio
SRC=test_gpio.c

SYSROOT=/home/channaveeragouda/bbb-dev/bbb-rootfs
INC_DIR=$(SYSROOT)/usr/include/arm-linux-gnueabihf
LIB_DIR=$(SYSROOT)/usr/lib/arm-linux-gnueabihf

CFLAGS= --sysroot=$(SYSROOT) -I$(INC_DIR) -Wall -o2
LDFLAGS= --sysroot=$(SYSROOT) -L$(LIB_DIR) -lgpiod

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

clean:
	rm -rf $(TARGET)
cptobbb:
	scp $(TARGET) debian@192.168.7.2:/home/debian/
.PHONY: all clean
