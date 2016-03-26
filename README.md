# Letter to A*

Convert US Letter PDFs to A3, A4, A5, etc.

This project is a very simple shell script to convert U.S. Letter PDF pages into A4 pages (and also any other "A" size), and then collate them into one combined PDF document.

Specifically, this works on the excellent [Mag-7 Star Atlas Project][mag7]. It is a very handy, twenty-page star atlas, if in an inconvenient paper size. So this script converts that to A4; and since we've already done that, we may as well generate A3 as an easy-to-see double-size format, as well as A5 as an easy-to-store half-size format.

## Downloads

The actual atlas files are available here (TODO).

## Usage

You can build the files yourself on Linux or OS X (or Windows with something like Cygwin). First you will need [GNU Ghostscript][gs]. Either install with *yum*, or *apt*, or for example on a Mac with [Homebrew][homebrew]:

``` sh
brew install ghostscript
```

Next, just clone this project and run the script:

``` sh
./letter-to-a4.sh
```

## Development

This script can easily be converted to work with other documents. Either fork it, or just learn from the Ghostscript calls for your own needs: see `convert_page()` and `collate()`.

## License

The source code in this project is licensed under the [Apache 2.0][apache2] license. The source material is under Creative Commons, SA-ND.

[apache2]: LICENSE
[gs]: http://www.ghostscript.com/
[homebrew]: http://brew.sh
[mag7]: http://www.cloudynights.com/page/articles/cat/articles/observing-skills/free-mag-7-star-charts-r1021
