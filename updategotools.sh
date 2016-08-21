#!/bin/sh

echo "Updating GoCode"
go get -u github.com/nsf/gocode

#go get -u github.com/alecthomas/gometalinter

echo "Updating GoImports"
go get -u golang.org/x/tools/cmd/goimports

echo "Updating Guru"
go get -u golang.org/x/tools/cmd/guru

echo "Updating GoRename"
go get -u golang.org/x/tools/cmd/gorename

echo "Updating GoLint"
go get -u github.com/golang/lint/golint

echo "Updating GoDef"
go get -u github.com/rogpeppe/godef

echo "Updating ErrCheck"
go get -u github.com/kisielk/errcheck

echo "Updating GoTags"
go get -u github.com/jstemmer/gotags
#go get -u github.com/klauspost/asmfmt/cmd/asmfmt

echo "Updating Motion"
go get -u github.com/fatih/motion

#go get -u github.com/zmb3/gogetdoc
#go get -u github.com/josharian/impl
