help: ## ヘルプを表示する
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))

up: ## コンテナを初期化します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
up-package: ## コンテナを初期化します（出来合いのパッケージを使います）
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
stop: ## コンテナを停止します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
down: ## コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
ps: ## コンテナを確認します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
bash: ## コンテナへログインします
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
# 現在Docker内か外か？を自動判定し分岐します
# Docker内環境からはローカルで実行します
# Docker外環境からはDocker環境を立ち上げ、そちらで実行するようにします
# どちらで実行するか強制したい場合は、ここより下にある、remote***やlocal***などの
# 接頭語がついたターゲットを使用してください
#
build: ## latexからpdfにコンパイルします(環境は自動判別)
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
lint: ## latexをLintにかけます(環境は自動判別)
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
clean: ## データ整理(環境は自動判別)
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
# コンテナ環境下でのビルド関連ターゲット
#
remotebuild: ## コンテナ環境にてlatexからpdfにコンパイルします
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
remotelint: ## コンテナ環境にてlatexをLintにかけます
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
remoteclean: ## コンテナ上のデータ整理
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
# ローカルでのビルド関連ターゲット
#
localbuild: pdf-files ## ローカル環境下でlatex→pdfにコンパイルします
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
pdf-files: $(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF)))
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
local-lint: ## ローカル環境下でlatexをlintにかけます
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
localclean: ## ローカル環境の不要ファイルを消します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
localup:
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
distclean: ## ローカル環境の不要ファイルを消し、latexのフォントキャッシュも消します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
#
name: ## 生成するスライド名を出力します
	$(error "$@" is not still suported for $(GOOS) on $(GOARCH))
