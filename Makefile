.PHONY: build build/background.js output/Main/index.js

build: output/Main/index.js

link: build/background.js

build/background.js: output/Main/index.js
	npx spago bundle-app -m Main -t $@

output/Main/index.js: | node_modules
	npx spago build

node_modules:
	npm install

pack: build/background.js
	npx web-ext build -i output -i lib
