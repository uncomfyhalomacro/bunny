# Bunny

🐇 **Bunny** is a static site generator written in [Harelang](https://harelang.org).

## Project Status

The project's goals for now is to try to at least export a markdown file to
an HTML file. It's still in its early stages and under heavy experimentation.

## Inspiration

The inspiration around the project is from [Boot.dev](https://boot.dev)'s
static site generator in Python. I am building this project out of curiosity of
the Hare programming language. I already made a project in Hare but I miss
the language so here we are.

### Bonus Inspiration

🐇 **Bunny** **won first place 🏆** in the **amateur category** of [Boot.dev's 2025 Hackathon](https://blog.boot.dev/news/hackathon-2025/).

Lane Wagner's review and reaction to the project:

> In July of 2025 we ran a 3-day hackathon, and Soc's project was a bit
> mind-melting. I couldn't believe someone was ambitious enough to build in
> Harelang, and not only that, but to tackle one of the harder project ideas
> for such a short time window - a static site generator! I poked through the
> project and played around with it, and honestly have nothing but nice
> things to say about Soc and their project, "Bunny"!

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
extensions. To install the library, just run the following command:

> A note before running the command. `HARESRCDIR` must be _indirectly_ set by `SRCDIR` before anything else.
> By default, it points to `/usr/local/src` but if you installed it using the AUR or openSUSE's zypper,
> then it should be in `/usr/src`. Hence, ensure you know where it is located and set `SRCDIR`
> and not `HARESRCDIR`. Refer to the [./Makefile](./Makefile) for other environmental variables.

```bash
export SRCDIR=/usr/src
make install-lib
```

> You may want to run this with `sudo` privileges.

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


See [./tests/](./tests/) to check on how each functionality behaves. See [./examples/](./examples/) to know how to use the library.

To run the tests, you can run the following command:

```bash
hare test tests
```

You can also run specific tests by specifying the file path:

```bash
hare test tests/mdextract.ha
```

Run specific examples by specifying the file path:

```bash
hare run examples/extract-media.ha
```

## Internal Documentation

To see library documentation or list of functions, you can run the following commands:

```bash
haredoc bunny
haredoc bunny::markdown
haredoc bunny::html
```

To show undocumented public functions and types, append the `-a` flag before the module name e.g.

```bash
haredoc -a bunny
haredoc -a bunny::markdown
haredoc -a bunny::html
```
