# ZDB

Text database tool, similar to `recutils` but with more compact search query
language (think: search engine) and color highlighting of matches. It uses a
'database' format, which, like the tool itself, is called ZDB. This format is
(intentionally) very simple, and built to be human readable above all.

It contains records which look like this:

```properties
# Tanada, Shigeru (2012). *Nihon shuwa kijutsu-hō (si5s hōshiki)* [Japanese
# Sign Language Notation (Si5s Method)] (in Japanese). Available at:
# https://shigeru-tanada.jimdofree.com/文字化の研究/ns-writing-日本手話記述法.
type    book
author  Tanada, Shigeru
pubdate 2012
title   Nihon shuwa kijutsu-hō (si5s hōshiki)
xtitle  Japanese Sign Language Notation (Si5s Method)
lang    ja
url     https://shigeru-tanada.jimdofree.com/文字化の研究/ns-writing-日本手話記述法
```

# Format Description


## Records

A file consist of any number of *records*.

A record consists of one or more *fields* and (optional) *comments*. Records
are separated from each other by one more blank lines followed by a *field
name* or a *comment.* (Blank lines which are followed by an indented line is a
continuation of any previous *field.*)


## Comments

A *comment* begins with `#` and ends at the end of the line. It cannot be
indented and may appear anywhere a *field* could.


## Fields

A *field* consist of a *field name* followed by one or more whitespaces and a
*field value*.

- *Field name*
  - Is never indented.
  - Matches the pattern `[_a-zA-Z%][_a-zA-Z0-9]*`.
  - Field names starting with `%` are special fields with ZDB settings.

- *Field value*
  - May contain any text.
  - May include blank lines or continuation lines.
  - Continuation lines must be indented by whitespace.


## Installation

The `zdb` 'binary' itself is just a Perl executable. Put it's somewhere in your
`$PATH` and you're ready to go.


## Extras

Included in this repository is a couple of extras related to ZDB files. You'll
find them in the `extras/` directory.

* [ZDB Syntax Highlighting][sublime-syntax] for Sublime Text (and `bat`)
* [`zdb-mode`][zdb-mode] for Emacs


### Config for `bat`

The syntax highlight file for `bat` (a `cat` clone with syntax highlighting,
git integration, and paging) is called `ZDB.sublime-syntax`. To install it, do
the following:

```sh
md ~/.config/bat/syntaxes/
cp -a extras/ZDB.sublime-syntax ~/.config/bat/syntaxes/
bat cache --build
```

ZDB looks best with a tab width of 8 characters. To get `bat` to output this,
you'll need to add a line to your `~/.config/bat/config`. Do the following:

```sh
echo '--tabs=8 --language ZDB' >>~/.config/bat/config
bat cache --build
```


### Emacs `zdb-mode`

Put the file [`extras/zdb-mode.el`][zdb-mode] where Emacs expects to find its
modules, then load in Emacs using `M-x load-file <RET> zdb-mode.el`.

[zdb-mode]: extras/zdb-mode.el
[sublime-syntax]: extras/zdb-mode.el

<!--[eof]-->
