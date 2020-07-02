# Minimal Makefile for Wii Homebrew
# Requires
# - devKitPPC installed and $DEVKITPRO and $DEVKITPPC paths configured
# - $DEVKITPPC/bin added to your $PATH

# Compiler and linker
CC = powerpc-eabi-gcc
LD = powerpc-eabi-gcc

# Machine dependent compiler flags
MACHDEP = -DGEKKO -mcpu=750 -mrvl -meabi -mhard-float

# Compiler flags
CFLAGS = \
	$(MACHDEP) \
	-g -O2 -Wall \
	-I$(DEVKITPRO)/libogc/include

# Linker flags
LDFLAGS = \
	$(MACHDEP) \
	-L$(DEVKITPRO)/libogc/lib/wii \
	-lwiiuse -lbte -logc -lm

# Clang support
ifdef CLANG
	include clang_rules.mk
endif

# Where to find source files
SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:.c=.o)

# Build .o files
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# Build .elf files
%.elf:
	$(LD) $^ $(LDFLAGS) -o $@

# Build .dol files
%.dol: %.elf
	elf2dol $< $@

# Main targets
boot.dol: boot.elf
boot.elf: $(OBJECTS)

# Clean
.PHONY: clean
clean:
	rm -f $(OBJECTS) boot.elf boot.dol