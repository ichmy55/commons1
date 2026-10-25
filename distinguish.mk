#
# OSとCPUアーキテクチャを判別する
# 
# 使用OSの判別
#
ifeq ($(OS),Windows_NT)
	GOOS := windows
	GOMAKEFILE := make-windows.mk
else
	IS_WSL := $(shell uname -r | grep -i microsoft)
	ifdef IS_WSL
		GOOS := wsl
		GOMAKEFILE := make-wsl.mk
        else
		UNAME_OS := $(shell uname -s)
		ifeq ($(UNAME_OS),Linux)
 			GOOS := linux
			GOMAKEFILE := make-linux.mk
		else ifeq ($(UNAME_OS),Darwin)
			GOOS := darwin
			GOMAKEFILE := make-mac.mk
		else
			GOOS := unknown
			GOMAKEFILE := make-unknown.mk
			$error("Error: OS unknown")
		endif
	endif
endif

#
# CPUアーキテクチャの判定
#
ifeq ($(OS),Windows_NT)
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		GOARCH := amd64
	else ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
			GOARCH := amd64
		else
			GOARCH := x86
		endif
	else ifeq ($(PROCESSOR_ARCHITECTURE),ARM64)
		GOARCH := arm64
	else
		GOARCH := unknown
		$error("Error: Architecture unknown")
	endif
else
	UNAME_MACHINE:=$(shell uname -m)
	ifeq ($(UNAME_MACHINE),x86_64)
		GOARCH := amd64
	else ifeq (${UNAME_MACHINE},i686)
		GOARCH := x86
	else ifeq (${UNAME_MACHINE},aarch64)
		GOARCH := arm64
	else ifeq (${UNAME_MACHINE},arm64)
		GOARCH := arm64-mac
	else
		GOARCH := unknown
		$error("Error: Architecture unknown")
	endif
endif
