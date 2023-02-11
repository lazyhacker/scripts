#!/bin/sh

export GO111MODULE=on

declare -a tools=(
github.com/davidrjenni/reftools/cmd/fillstruct@master
github.com/fatih/gomodifytags@latest
github.com/fatih/motion@latest
github.com/go-delve/delve/cmd/dlv@latest
github.com/golangci/golangci-lint/cmd/golangci-lint@latest
github.com/josharian/impl@main
# github.com/jstemmer/gotags@latest
github.com/jstemmer/gotags@master
github.com/kisielk/errcheck@latest
github.com/klauspost/asmfmt/cmd/asmfmt@latest
github.com/koron/iferr@master
github.com/mgechev/revive@latest
github.com/nsf/gocode@latest
github.com/rogpeppe/godef@latest
github.com/zmb3/gogetdoc@latest
golang.org/x/lint/golint@latest
golang.org/x/tools/cmd/godoc@latest
# golang.org/x/tools/cmd/goimports@latest
golang.org/x/tools/cmd/goimports@master
# golang.org/x/tools/cmd/gorename@latest
golang.org/x/tools/cmd/gorename@master
# golang.org/x/tools/cmd/guru@latest
golang.org/x/tools/cmd/guru@master
golang.org/x/tools/cmd/present@latest 
golang.org/x/tools/gopls@latest
honnef.co/go/tools/cmd/keyify@master
honnef.co/go/tools/cmd/staticcheck@latest
)

for i in "${tools[@]}"
do
    echo $i
	go install $i
done
