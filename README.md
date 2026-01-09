# ZDB

ZDB is a text database utility (similar to `recutils`). It features a compact
query language (think: search engine), highlighting of matches, and a single
command used for both searching and updating the database. It uses a 'database'
format, which, like the utility itself, is called ZDB. This format is
(intentionally) very simple, and is built to be human-readable above all.

```
# A friend of mine.
name    Nomi Marks
address San Francisco
        California
born    1988, August 8

# Another friend of mine.
name    Amanita Caplan
address San Francisco
        California
# Ask about bday?
```


# Format Description

A database consists of *records,* *fields,* *special fields* and *comments.*


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

The `zdb` program itself is just a Perl executable. Put anywhere in your
`$PATH` and you're ready to go. Docs come built-in using `zdb --help` and `zdb
--manual`.


## Extras

Included in this repository is a couple of extras related to ZDB files. You'll
find them in the `extras/` directory.

* [ZDB Syntax Highlighting][sublime-syntax] for Sublime Text (and `bat`)
* [`zdb-mode`][zdb-mode] for Emacs


### Config for `bat`

The syntax highlight file for `bat` (a `cat` clone with syntax highlighting,
git integration, and paging) is called `ZDB.sublime-syntax`. To install it, do
the following:

```
md ~/.config/bat/syntaxes/
cp -a extras/ZDB.sublime-syntax ~/.config/bat/syntaxes/
bat cache --build
```

ZDB looks best with a tab width of 8 characters. To get `bat` to output this,
you'll need to add a line to your `~/.config/bat/config`. Do the following:

```
echo '--tabs=8 --language ZDB' >>~/.config/bat/config
bat cache --build
```


### Emacs `zdb-mode`

Put the file [`extras/zdb-mode.el`][zdb-mode] where Emacs expects to find its
modules, then load in Emacs using `M-x load-file <RET> zdb-mode.el`.

[zdb-mode]: extras/zdb-mode.el
[sublime-syntax]: extras/zdb-mode.el

<!--[eof]-->
