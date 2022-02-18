ASM=nasm
QEMU=qemu-system-i386

SRC_DIR=src
BUILD_DIR=build

.PHONY: all floppy_image kernel bootloader clean always

run: $(BUILD_DIR)/main_floppy.img
	$(QEMU) -drive format=raw,file=$(BUILD_DIR)/main_floppy.img 

#
# floppy image
#
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	cp $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

#
# bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

#
# kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# always
#
always:
	mkdir -p $(BUILD_DIR)

#
# clean
#
clean:
	rm -rf $(BUILD_DIR)/*



