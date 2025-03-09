build-web:
	./scripts/web_build.sh

build:
	./scripts/desktop_build.sh
run:
	mkdir -p build/desktop
	odin run flavors/desktop -out:build/desktop/game.exe