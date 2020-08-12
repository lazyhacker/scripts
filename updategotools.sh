#!/bin/sh

export GO111MODULE=on

echo "Updating GoCode"
go get -u github.com/nsf/gocode

#go get -u github.com/alecthomas/gometalinter

echo "Updating GoImports"
go get golang.org/x/tools/cmd/goimports@master

echo "Updating Guru"
go get golang.org/x/tools/cmd/guru@master

echo "Updating GoRename"
go get golang.org/x/tools/cmd/gorename@master

echo "Updating GoLint"
go get golang.org/x/lint/golint@master

echo "Updating GoDef"
go get github.com/rogpeppe/godef@master

echo "Updating ErrCheck"
go get github.com/kisielk/errcheck@master

echo "Updating GoTags"
go get github.com/jstemmer/gotags@master
#go get -u github.com/klauspost/asmfmt/cmd/asmfmt

echo "Updating Motion"
go get github.com/fatih/motion@master

echo "Update gogetdoc"
go get github.com/zmb3/gogetdoc@master
#go get -u github.com/josharian/impl

echo "Update gopls"
go get golang.org/x/tools/gopls@latest

echo "Update gomodifytags"
go get github.com/fatih/gomodifytags@master

echo "Update present"
go get golang.org/x/tools/cmd/present 

#go get github.com/ChimeraCoder/gojson/gojson

