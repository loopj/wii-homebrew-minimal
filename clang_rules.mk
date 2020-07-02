#---------------------------------------------------------------------------------
# devkitPPC rules for building with Clang
#
# How to use:
# - Copy this file into your DEVKITPPC path:
#   cp wii_clang_rules $DEVKITPPC
#
# - Link Clang into your DEVKITPPC path:
#   ln -s `which clang` $DEVKITPPC/bin/powerpc-eabi-clang
#
# - Include this file in your Makefile, as the last line
#   include $(DEVKITPPC)/wii_clang_rules
#
# Note:
# - If you are using macOS you'll need to install llvm from homebrew, since
#   Apple's version doesn't support cross-compiling to the ppc32 target
#---------------------------------------------------------------------------------

# Use Clang instead of GCC (we'll still use GCC/LD to link)
CC = powerpc-eabi-clang --target=ppc32-none-eabi

# Override MACHDEP to pass compiler flags typically passed by -mrvl
MACHDEP = \
	-DGEKKO -mcpu=750 \
	-D__wii__ -DHW_RVL -ffunction-sections -fdata-sections

# Point Clang to the powerpc-eabi stdlibs
CFLAGS += -nostdlibinc -isystem $(DEVKITPPC)/powerpc-eabi/include

# Use custom startfile/endfiles
LDFLAGS += \
	-Wl,--gc-sections -nostartfiles\
	$(DEVKITPPC)/lib/gcc/powerpc-eabi/*/crtend.o \
	$(DEVKITPPC)/lib/gcc/powerpc-eabi/*/ecrtn.o \
	$(DEVKITPPC)/lib/gcc/powerpc-eabi/*/ecrti.o \
	$(DEVKITPPC)/lib/gcc/powerpc-eabi/*/crtbegin.o \
	$(DEVKITPPC)/powerpc-eabi/lib/crtmain.o

# Link with libsysbase.a and libc.a
LDFLAGS += -L$(DEVKITPPC)/powerpc-eabi/lib
LDFLAGS += -Wl,--start-group -lsysbase -lc -Wl,--end-group

# Use the Wii linkscript
LDFLAGS += -Trvl.ld