#
# ターゲット一覧
#
.PHONY: help up up-package stop down ps bash build lint clean remotebuild remotelint remoteclean localbuild local-lint localclean distclean name localup pdf-files
.ONESHELL: up
.DEFAULT_GOAL := help

#
MAKEDIR := src/commons1
#
# プロジェクト毎設定の読み込み
#
include variables.mk
#
include $(MAKEDIR)/distinguish.mk
include $(MAKEDIR)/$(GOMAKEFILE)
