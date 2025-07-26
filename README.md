# Bunny

🐇 **Bunny** is a static site generator written in [Harelang](https://harelang.org).

## Inspiration

The inspiration around the project is from [Boot.dev](https://boot.dev)'s
static site generator in Python. I build this project out of curiosity of
the Hare programming language. I already made a project in Hare but I miss
the language so here we are.

## Features 🚧

# Dependencies

- a c compiler like `gcc` or `clang`.
- a harelang installation. Hare is available in the [AUR](https://aur.archlinux.org/packages/hare). If you use openSUSE, just run `sudo zypper in hare`.
- `make` or `gmake` command for the `Makefile`.

# How To Use 🚧

## Library

🐇 **Bunny** is not only an SSG but it also provides a simple markdown
parser and a markdown to html exporter. The intended goal in the future is
to be [CommonMark](https://spec.commonmark.org/) spec compliant with custom
extensions). To use the library, just run the following command:

```bash
make install-lib
```

You may want to run this with `sudo` privileges.
