build-web:
	./scripts/web_build.sh

build:
	./scripts/desktop_build.sh
run:
	odin run flavors/desktop -out:build/desktop/game.exe