use strings;

export type texttype = (mdpair | media);

export type mdpair = enum {
	TEXT,  // Technically not a pair
	BOLD,
	INLINE_CODE,
	ITALIC,
};

export type media = enum {
	LINK,
	IMAGE
};

export type pair_info = struct {
	start: size,
	end: size,
	text: str
};

// This should return a list
// of pair_infos.
export fn extract_text_from_pair(pair: mdpair, line: str) []pair_info = {
	switch (pair) {
		case mdpair::TEXT =>
    		let new_pair_info = pair_info {
    			start= 0z,
    			end= len(line),
    			text= line,
    		};
		return [new_pair_info];
		case mdpair::INLINE_CODE =>
    			return _extract_inline_code(line);
		case mdpair::ITALIC =>
    			return _extract_italicized_text(line);
		case =>
    		let new_pair_info = pair_info {
    			start= 0z,
    			end= 0z,
    			text= "",
    		};
    		return [new_pair_info];
	};
};

fn _extract_inline_code(line: str) []pair_info = {
	let pairs: []pair_info = [];
	let pair = pair_info {
		start= 0z,
		end= 0z,
		text= ""
	};
	let ispairfound = false;
	let iter = strings::iter(line);
	let found_first_pair = false;
	let found_end_pair = false;
	let found_count = 0;
	let index = 0z;
	for (true) {
		let r = strings::next(&iter);
		if (r is done) {
			break;
		};
		index = index + 1;
		if (r == '`') {
			found_first_pair = true;
			if (found_count == 1) {
        			pair.end = index - 1; // a little offset to the left
        			pair.text = strings::sub(line, pair.start, pair.end);
        			append(pairs, pair)!;
        			found_first_pair = false;
        			found_count = 0;
			};
		};
		if (found_first_pair) {
			pair.start = index;
			found_count = found_count + 1;
			found_first_pair = false;
		};
	};
	return pairs;
};

fn _extract_italicized_text(line: str) []pair_info = {
	let pairs: []pair_info = [];
	let pair = pair_info {
		start= 0z,
		end= 0z,
		text= ""
	};
	let ispairfound = false;
	let iter = strings::iter(line);
	let found_first_pair = false;
	let found_end_pair = false;
	let found_count = 0;
	let index = 0z;
	for (true) {
		let r = strings::next(&iter);
		if (r is done) {
			break;
		};
		index = index + 1;
		if (r == '_') {
			found_first_pair = true;
			if (found_count == 1) {
        			pair.end = index - 1; // a little offset to the left
        			pair.text = strings::sub(line, pair.start, pair.end);
        			append(pairs, pair)!;
        			found_first_pair = false;
        			found_count = 0;
			};
		};
		if (found_first_pair) {
			pair.start = index;
			found_count = found_count + 1;
			found_first_pair = false;
		};
	};
	return pairs;
};
export fn parseline(line: str) (texttype | void) = {
	return;
};

