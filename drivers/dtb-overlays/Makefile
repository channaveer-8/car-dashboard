obj-m += vehicle_sensor.o

KERNEL_SRC ?= ../../linux/linux-6.18.35
TOOLCHAIN_PREFIX ?= /home/channaveeragouda/bbb-dev/toolchain/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-

all: dtbo module

dtbo:
	cpp -nostdinc -I$(KERNEL_SRC)/include -undef bbb-uart1.dts | dtc -@ -I dts -O dtb -o bbb-uart1.dtbo -

module:
	make -C $(KERNEL_SRC) M=$(PWD) ARCH=arm CROSS_COMPILE=$(TOOLCHAIN_PREFIX) modules

clean:
	rm -f bbb-uart1.dtbo
	make -C $(KERNEL_SRC) M=$(PWD) ARCH=arm CROSS_COMPILE=$(TOOLCHAIN_PREFIX) clean
