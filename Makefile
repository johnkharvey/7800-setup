# Makefile to fetch the 7800 ROMS

#==================
# Global Variables
#==================
# Latest as of 12/24/2022 - https://github.com/7800-devtools/a7800/tags
A7800_VERSION=v5.2
# Additional files (e.g. 7800.rom)
ADDITIONAL_FILES_VERSION=188-03

#ROMPACK_VERSION=v3_5
# A7800 dependency
#SDL2_VERSION=2.0.10

#=========
# Aliases
#=========
# 7800-specific runtime tools
A7800=${HOME}/emulators/atari7800/a7800/a7800
#SDL2=/Library/Frameworks/SDL2.framework/SDL2

# OS-level Tools
WGET=/opt/homebrew/bin/wget
TAR=/usr/bin/tar
UNZIP=/usr/bin/unzip
#SLEEP=/bin/sleep

#===============
# Build Targets
#===============
.PHONY:	all run clean

default:	${A7800}

#all:	zip/Trebors_7800_ROM_PROPack_${ROMPACK_VERSION}.zip
#
#zip/Trebors_7800_ROM_PROPack_${ROMPACK_VERSION}.zip:	${WGET} 
#	mkdir -p zip
#	cd zip && wget http://7800.8bitdev.org/images/7/7b/Trebors_7800_ROM_PROPack_${ROMPACK_VERSION}.zip
#	# Do a touch so it doesn't keep appearing out-of-date
#	find zip/ -type f -exec touch {} +

# Special variable to only initialize tools.  Not generally used.
#setup:  ${WGET} ${SDL2} ${A7800}

${WGET}:
	brew install wget

#${SDL2}:	${WGET}
#	mkdir -p tmp/
#	wget -O tmp/SDL2.dmg https://www.libsdl.org/release/SDL2-${SDL2_VERSION}.dmg
#	cd tmp && sudo hdiutil attach SDL2.dmg
#	sudo cp -r /Volumes/SDL2/SDL2.framework /Library/Frameworks/
#	sleep 1
#	sudo hdiutil detach /Volumes/SDL2
#	rm -rf tmp

${A7800}:	${WGET} ${UNZIP}
	# Setup install directory info
	mkdir -p ${HOME}/emulators/atari7800/a7800/
	cd ${HOME}/emulators/atari7800/a7800/

	# Download the a7800 binary, extract, place in location
	mkdir -p ${HOME}/emulators/atari7800/a7800/tmp/
	${WGET} -O ${HOME}/emulators/atari7800/a7800/tmp/a7800.tgz https://github.com/7800-devtools/a7800/releases/download/${A7800_VERSION}/a7800-osx-${A7800_VERSION}.tgz
	cd ${HOME}/emulators/atari7800/a7800/tmp && ${TAR} zxf a7800.tgz
	cd ${HOME}/emulators/atari7800/a7800/ && cp tmp/a7800-osx/a7800 ./
	rm -rf ${HOME}/emulators/atari7800/a7800/tmp

	# Configure our ini file
	mkdir -p ~/.a7800
	cd ${HOME}/emulators/atari7800/a7800 && ./a7800 -cc
	mv ${HOME}/emulators/atari7800/a7800/a7800.ini ~/.a7800
	rm -f ${HOME}/emulators/atari7800/a7800/ui.ini
	rm -f ${HOME}/emulators/atari7800/a7800/plugin.ini

	# We need the 7800.rom file (found here: https://atariage.com/forums/topic/268458-a7800-the-atari-7800-emulator/)
	mkdir -p ${HOME}/emulators/atari7800/a7800/tmp/
	wget -O ${HOME}/emulators/atari7800/a7800/tmp/Additional_Files_a7800_v0188-01.zip https://atariage.com/forums/applications/core/interface/file/attachment.php?id=521608
	cd ${HOME}/emulators/atari7800/a7800/tmp && ${UNZIP} Additional_Files_a7800_v0188-01.zip
	rm -rf ${HOME}/emulators/atari7800/a7800/tmp

#===============
# Run Targets
#===============
run:	${A7800}
	cd ${HOME}/emulators/atari7800/a7800/ && ./a7800 a7800 -cart ${HOME}/git/7800/out/getlost.a78


#===============
# Clean Targets
#===============
clean:
	rm -rf  ${HOME}/emulators/atari7800
