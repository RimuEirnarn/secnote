# No one wants 3 interfaces by default.

all: build_cli build_gui build_web build_server

build_cli:
	echo "build cli"

build_gui:
	echo "build gui"

build_web:
	echo "build web"

build_server:
	echo "build server"

.PHONY: localinstall
localinstall:
	echo "install as $UID"

.PHONY: globalinstall
globalinstall:
	echo "install for global uses, exe at /usr/local/bin"

.PHONY: serverinstall
serverinstall:
	echo "install for server-mode. exe at /srv/app-name/bin"

