# Bunny

🐇 **Bunny** is a static site generator written in [Harelang](https://harelang.org).

## Project Status

The project's goals for now is to try to at least export a markdown file to
an HTML file. It's still in its early stages and under heavy experimentation.

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

🐇 **Bunny** is not only an SSG but it also _**provides a simple markdown
parser and a markdown to html exporter library**_. The intended goal in the future is
to be [CommonMark](https://spec.commonmark.org/) spec compliant with custom
extensions. To use the library, just run the following command:

```bash
make install-lib
```

Once installed, you can then put this to your Harelang code.

```hare
use bunny::markdown;
use fmt;

fn print_medias() void = {
	let md = "[alt text](https://example.com) and ![alt text](https://images.com)";
	let links = markdown::extract_media(markdown::media::LINK, md);
	for (let link .. links) {
		fmt::printfln("alt={}, url={}", link.alt_text, link.url)!;  // should print 'alt=alt text, url=https://example.com'
	};
};
```


See [./tests/](./tests/) for check for how each functionality behaves.

You may want to run this with `sudo` privileges.
