# ZDB

Text database tool, similar to `recutils` but with more compact search query
language (think: search engine) and color highlighting of matches.


## Installation

The `zdb` 'binary' itself is just a Perl executable. Make sure it's somewhere
in your `$PATH` and you're ready to go.


### Config for `bat`

The syntax highlight file for `bat` (a `cat` clone with syntax highlighting,
git integration, and paging) is called `ZDB.sublime-syntax`. To install it, do
the following:

```sh
md ~/.config/bat/syntaxes/
cp -a ZDB.sublime-syntax ~/.config/bat/syntaxes/
bat cache --build
```

ZDB looks best with a tab width of 8 characters. To get `bat` to output this,
you'll need to add a line to your `~/.config/bat/config`. Do the following:

```sh
echo '--tabs=8 --language ZDB' >>~/.config/bat/config
bat cache --build
```


### Emacs `zdb-mode`

Put the file `zdb-mode.el` where Emacs expects to find its modules, then load
in Emacs using `M-x load-file <RET> zdb-mode.el`.

<!--[eof]-->
