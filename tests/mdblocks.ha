use bunny::markdown;
use fmt;

@test fn split_to_block_infos() void = {
	let md =
"""
# Libnotify bindings for Hare

Experimenting <https://harelang.org> on C binding feature.

## Install

Run `make install` to install both the third-party library and the `notify-send` binary.

If you want the library only, run `make install-lib`.

```bash
run code block more
```

### Dependencies

#### Other stuff

1. This is an item
2. No stuff in the next item
3.
4. Now have stuff

- a c compiler e.g. `clang` or `gcc`.
- a harelang installation (version 0.25.2)
- a development package install of `libnotify` and its own dependencies.

> I am the storm that is approaching 😔
""";
	let markdown_blockinfos = markdown::generate_blocks(md); // 11 elements
	assert(len(markdown_blockinfos) == 11, "This should generate at least 11 blocks!");
	for (let i = 0z; i < len(markdown_blockinfos); i+=1) {
		let blockinfo = markdown_blockinfos[i];
		if (i == 0) {
			let block = "# Libnotify bindings for Hare";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::H1, "Not the expected block kind!");
		};
		if (i == 1) {
			let block = "Experimenting <https://harelang.org> on C binding feature.";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::PARAGRAPH, "Not the expected block kind!");
		};
		if (i == 2) {
			let block = "## Install";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::H2, "Not the expected block kind!");
		};
		if (i == 3) {
			let block = "Run `make install` to install both the third-party library and the `notify-send` binary.";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::PARAGRAPH, "Not the expected block kind!");
		};
		if (i == 4) {
			let block = "If you want the library only, run `make install-lib`.";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::PARAGRAPH, "Not the expected block kind!");
		};
		if (i == 5) {
			let block ="""```bash
run code block more
```""";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::CODEBLOCK, "Not the expected block kind!");
		};
		if (i == 6) {
			let block = "### Dependencies";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::H3, "Not the expected block kind!");
		};
		if (i == 7) {
			let block = "#### Other stuff";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::H4, "Not the expected block kind!");
		};
		if (i == 8) {
			let block ="""1. This is an item
2. No stuff in the next item
3.
4. Now have stuff""";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::ORDERED_LIST, "Not the expected block kind!");
		};
		if (i == 9) {
			let block = """- a c compiler e.g. `clang` or `gcc`.
- a harelang installation (version 0.25.2)
- a development package install of `libnotify` and its own dependencies.""";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::UNORDERED_LIST, "Not the expected block kind!");
		};
		if (i == 10) {
			let block = "> I am the storm that is approaching 😔";
			assert(blockinfo.block == block, "Not the expected extracted block!");
			assert(blockinfo.kind == markdown::block_kind::BLOCKQUOTE, "Not the expected block kind!");
		};
	};
};
