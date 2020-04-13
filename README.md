# Image Redirecter

A firefox extension for imgur.com. It automatically redirects you from image
pages to images themselves without ever loading the page. So if your friend
sends you a link to `https://imgur.com/nWjVtF1`, it will automatically redirect
you to `https://i.imgur.com/nWjVtF1.png`

## Building

Before building ensure that all submodules are present:
`git submodule update --init`

If you have received this source via something other than git, you should
instead install the submodules by hand:
`git clone https://gitlab.com/d86leader/purescript-web-extensions lib/web-extensions`

Building requires npm and GNU Make. Go into the extension folder and write
`make link` - this will install the deps and build everything for you. Then you
can just load `manifest.json` in your browser, and it will work.

### Building manually

This project is written with `purescript` and built with `spago`. First you
should install those with npm: `npm install`
Then you can build the app: `npx spago build`
And after that, bundle it into an executable js file:
`npx spago bundle-app -m Main -t build/background.js`

## License

Created by d86leader, 2020. Distributed under GNU GPL v3. You should have
received a copy of this license with this software [here](./LICENSE)
