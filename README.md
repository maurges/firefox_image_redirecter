# Image Redirecter

A firefox extension for imgur.com. It automatically redirects you from image
pages to images themselves without ever loading the page. So if your friend
sends you a link to `https://imgur.com/nWjVtF1`, it will automatically redirect
you to `https://i.imgur.com/nWjVtF1.png`

## Building

Requires npm. Go into the extension folder and write `make link` - this will
install and build everything for you. Than you can just load `manifest.json` in
your browser, and it will work.
