use strings;
use fmt;
use ascii;

export type block_kind = enum {
	PARAGRAPH,
	BLOCKQUOTE,
	CODEBLOCK,
	UNORDERED_LIST,
	ORDERED_LIST,
	H1,
	H2,
	H3,
	H4,
	H5,
	H6
};

export type block_info = struct {
	kind: block_kind,
	block: str
};

// Common identifiers
// "- " is a unordered list
// "1. " is a ordered list
// "```custom language" is a code block
// "> " is a block quote
export fn generate_blocks(md: str) []block_info = {
	let block_infos: []block_info = [];
	let blks = _split_to_blocks(strings::trim(md));
	for (let blk .. blks) {
		if (_starts_with(blk, "> ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::BLOCKQUOTE,
					block= blk,
				}
			)!;
		} else if (_starts_with(blk, "```").1 && _ends_with(blk, "```").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::CODEBLOCK,
					block= blk,
				}
			)!;
		} else if (_starts_with(blk, "- ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::UNORDERED_LIST,
					block= blk,
				}
			)!;
		} else if (_starts_with(blk, "# ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H1,
					block= blk,
				}
			)!;

		} else if (_starts_with(blk, "## ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H2,
					block= blk,
				}
			)!;

		} else if (_starts_with(blk, "### ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H3,
					block= blk,
				}
			)!;

		} else if (_starts_with(blk, "#### ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H4,
					block= blk,
				}
			)!;
		} else if (_starts_with(blk, "##### ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H5,
					block= blk,
				}
			)!;
		} else if (_starts_with(blk, "###### ").1) {
			append(
				block_infos,
				block_info {
					kind= block_kind::H6,
					block= blk,
				}
			)!;
		} else if (_starts_with_numbered_item(blk)) {
			append(
				block_infos,
				block_info {
					kind= block_kind::ORDERED_LIST,
					block= blk,
				}
			)!;
		} else {
			append(
				block_infos,
				block_info {
					kind= block_kind::PARAGRAPH,
					block= blk,
				}
			)!;
		};
	};
	return block_infos;
};

fn _split_to_blocks(md: str) []str = {
	let ret: []str = [];
	let c = strings::cut(md, "\n\n");
	for (true) {
		if (c.1 == "") {
        		append(ret, strings::trim(c.0))!;
			break;
		};
		append(ret, strings::trim(c.0))!;
		c = strings::cut(c.1, "\n\n");
	};
	return ret;
	// TODO: report bug? strings::split with '\n\n' delimiter seems to behave as '\n'
	// let ret: []str = [];
	// let splits_ = strings::split(md, "\n\n")!;
	// for (let sp .. splits_) {
	// 	append(ret, strings::trim(sp))!;
	// };
	// return ret;

};

fn _starts_with_numbered_item(haystack: str) bool = {
	let iter = strings::iter(haystack);
	let isnumbered_item = false;
	let allbools: []bool = [];
	let ret = true;
	let idx = 0;
	for (true) {
		let r = strings::next(&iter);
		if (r is done) {
			return false;
		};
		if (ascii::isdigit(r as rune)) {
			append(allbools, true)!;
			continue;
		};
		if (!ascii::isdigit(r as rune) && r == '.') {
			append(allbools, true)!;
			continue;
		} else {
			if (r == ' ') {
				append(allbools, true)!;
				break;
			};
			return false;
		};
	};
	for (let b .. allbools) {
		ret = ret && b;
	};
	return ret;
};

fn _starts_with(haystack: str, sub: str) (str, bool) = {
	let new_string = strings::trimprefix(haystack, sub);
	if (new_string == haystack) {
		return (haystack, false);
	};
	return (new_string, true);
};

fn _ends_with(haystack: str, sub: str) (str, bool) = {
	let new_string = strings::trimsuffix(haystack, sub);
	if (new_string == haystack) {
		return (haystack, false);
	};
	return (new_string, true);
};
