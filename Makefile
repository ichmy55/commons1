#
# Texをコンパイルする環境を作成する Makefile
#
.ONESHELL:
#
# ターゲット一覧
#
.PHONY: help up up-package stop down ps bash build lint clean remotebuild remotelint remoteclean localbuild local-lint localclean distclean name localup diff
.DEFAULT_GOAL := help
#
# Docker コマンドマクロ
#
DOCKER := docker
#
# Latex エンジン
#
LATEXENG := lualatex
BIBTEXENG := pbibtex
# 
# Makefileのファイル名
HELPFILE := $(MAKEFILE_LIST)
#
# プロジェクト毎設定の読み込み
#
include variables.mk
#
# ソースファイル一覧
#
SRCDIR  := src/$(DEST_PDF)
SRCDIR2 := src/commons
SRCS    := $(wildcard  $(SRCDIR)/*.tex)  $(wildcard  $(SRCDIR)/*.bst)  $(wildcard  $(SRCDIR)/*.bib)
SRCS2   := $(wildcard  $(SRCDIR)/images/*)
SRCS3   := $(wildcard  $(SRCDIR2)/*.tex)
SRCS4   := $(wildcard  $(SRCDIR2)/images/*)
SRCS5   := $(SRCS) $(SRCS2) $(SRCS3) $(SRCS4)
DOCS    := $(wildcard  $(SRCDIR2)/docs/*.md)
#
# Makefile内で使用するshellを定義
SHELL=/bin/bash
#
help: ## ヘルプを表示する
	@echo "Command list:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(HELPFILE) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
#
# Docker compose 制御ターゲット
#
up: ## コンテナを初期化します
	make down
	rm -rf ltcache
	mkdir ltcache
	if [ $(PACKAGE_USE) -eq 1 ]; then 
	  $(DOCKER) pull $(DOCKER_IMAGE)
	  $(DOCKER) run -d -v $(PWD)/src:/home/ubuntu/src -v $(PWD)/rules:/home/ubuntu/rules  -v$(PWD)/ltcache:/home/ubuntu/.texlive2023 --name $(DOCKER_NAME) $(DOCKER_IMAGE)
	else 
	  $(DOCKER) build . -t $(DOCKER_NAME)
	  $(DOCKER) run -d -v $(PWD)/src:/home/ubuntu/src -v $(PWD)/rules:/home/ubuntu/rules  -v$(PWD)/ltcache:/home/ubuntu/.texlive2023 --name $(DOCKER_NAME) $(DOCKER_NAME)
	fi
	make remoteclean
	$(DOCKER) exec -it $(DOCKER_NAME) luaotfload-tool --update
#
up-package: ## コンテナを初期化します（出来合いのパッケージを使います）
	PACKAGE_USE   := 1
	make up
#
stop: ## コンテナを停止します
	@$(DOCKER) stop $(DOCKER_NAME)
#
down: ## コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
	@$(DOCKER) rm -f  $(DOCKER_NAME)
#
ps: ## コンテナを確認します
	@$(DOCKER) ps -a
#
bash: ## コンテナへログインします
	@$(DOCKER) exec -it $(DOCKER_NAME) /bin/bash
#
# 現在Docker内か外か？を自動判定し分岐します
# Docker内環境からはローカルで実行します
# Docker外環境からはDocker環境を立ち上げ、そちらで実行するようにします
# どちらで実行するか強制したい場合は、ここより下にある、remote***やlocal***などの
# 接頭語がついたターゲットを使用してください
#
build: ## latexからpdfにコンパイルします(環境は自動判別)
ifndef CONTAINER_ENV
	make remotebuild
else
	make localbuild
endif
#
lint: ## latexをLintにかけます(環境は自動判別)
ifndef CONTAINER_ENV
	make remotelint
else
	make local-lint
endif
clean: ## データ整理(環境は自動判別)
ifndef CONTAINER_ENV
	make remoteclean
else
	make localclean
endif
#
# コンテナ環境下でのビルド関連ターゲット
#
remotebuild: ## コンテナ環境にてlatexからpdfにコンパイルします
	make remoteclean
	@$(DOCKER) exec -it $(DOCKER_NAME) make localbuild
	@$(DOCKER) cp $(DOCKER_NAME):/home/ubuntu/dist .
#
# 
remotelint: ## コンテナ環境にてlatexをLintにかけます
	make remoteclean
	@$(DOCKER) exec -it $(DOCKER_NAME) make local-lint
#
remoteclean: ## コンテナ上のデータ整理（いったん全部消して、ローカルから持上）
	make localclean
	@$(DOCKER) cp ./Makefile  $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp ./variables.mk  $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp README.md $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp .textlintrc.json $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp VERSION.txt $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) exec -it $(DOCKER_NAME) make localclean
#
# ローカルでのビルド関連ターゲット
#
localbuild: pdf-files ## ローカル環境下でlatex→pdfにコンパイルします

pdf-files: $(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF)))
$(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF))) : $(SRCS5)
	make localclean
	make localup
	cd work
	@$(LATEXENG)  000-main.tex
	@$(BIBTEXENG) 000-main
	@$(LATEXENG)  000-main.tex
	@$(LATEXENG)  000-main.tex
	mv 000-main.pdf ../$@
	cd ..

local-lint: ## ローカル環境下でlatexをlintにかけます
	npx textlint -f pretty-error README.md $(SRCS) $(DOCS)

localclean: ## ローカル環境の不要ファイルを消します
	rm -rf  000-main.* work dist; mkdir -p dist work

localup:
	cp -rL $(SRCDIR2)/tex/* work/
	cp -rL $(SRCDIR2)/images work/
	cp -rL $(SRCDIR)/* work/
	cp VERSION.txt  work/

distclean: ## ローカル環境の不要ファイルを消し、latexのフォントキャッシュも消します
	make localclean
	rm -rf  ltcache

name: ## 生成するスライド名を出力します
	@echo "DEST_PDF=$(DEST_PDF).pdf"
