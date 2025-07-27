use strings;
use fmt;

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

export type media_info = struct {
	start: size,
	end: size,
	alt_text: str,
	url: str
};

export type pair_info = struct {
	start: size,
	end: size,
	text: str
};

export fn extract_media(med: media, line: str) []media_info= {
	switch (med) {
		case media::LINK =>
			return _extract_linked_text(line);
		case =>
			fmt::fatalf("Error: Unknown media type. Is this enum variant implemented?");
	};
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
		case mdpair::BOLD =>
			return _extract_boldened_text(line);
		case =>
			fmt::fatalf("Error: Unknown mdpair type. Is this enum variant implemented?");
	};
};

fn _extract_boldened_text(line: str) []pair_info = {
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
		if (r == '*') {
			r = strings::next(&iter);  // do it again
			if (r is done) {
				break;
			};
			index = index + 1;
			if (r == '*') {
				found_first_pair = true;
				if (found_count == 1) {
					pair.end = index - 2; // a little offset to the left
					pair.text = strings::sub(line, pair.start, pair.end);
					append(pairs, pair)!;
					found_first_pair = false;
					found_count = 0;
				};
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

fn _extract_linked_text(line: str) []media_info= {
	let infos: []media_info = [];
	let info = media_info {
		start= 0z,
		end= 0z,
		alt_text= "",
		url= ""
	};
	let ispairfound = false;
	let iter = strings::iter(line);
	let found_first_bracket_pair = false;
	let found_first_parenthesis_pair = false;
	let found_bracket_count = 0;
	let found_parenthesis_count = 0;
	let index = 0z;
	// TODO: implement regex checks for URL partition.
	for (true) {
		let r = strings::next(&iter);
		index = index + 1;
		if (r is done) {
			break;
		};
		if (r == '!') {
			r = strings::next(&iter);
			if (r is done) {
				break;
			};
			index+=1;
			if (r == '[') {  // logic here is to not get anything that starts with ! since they are for images.
				found_first_bracket_pair = false;
				found_first_parenthesis_pair = false;
				found_bracket_count = 0;
        			continue;
			};  // else just go along..
		};
		if (r == '[') {
			found_first_bracket_pair = true;
			found_first_parenthesis_pair = false;
		};
		if (found_first_bracket_pair) {
			info.start = index;
			found_bracket_count += 1;
			found_first_bracket_pair = false;
		};
		if (r == ']') {
			if (found_bracket_count == 1) {
				info.alt_text = strings::sub(line, info.start, index - 1);
				found_bracket_count += 1;
			};
		};
		if (found_bracket_count == 2) {
			r = strings::next(&iter);
			if (r is done) {
				break;
			};
			index += 1;
			if (r == '(') {
				found_first_parenthesis_pair = true;
				found_bracket_count = 0;
			};
		};
		if (found_first_parenthesis_pair) {
			found_parenthesis_count += 1;
			found_first_parenthesis_pair = false;
		};
		if (found_parenthesis_count == 1) {
			if (r == ')') {
				info.end = index - 1;
				info.url = strings::sub(line, info.start + (len(info.alt_text)) + 2, info.end);
				found_first_bracket_pair = false;
				found_first_parenthesis_pair = false;
				found_bracket_count = 0;
				found_parenthesis_count = 0;
				append(infos, info)!;
			};
		};
	};
	return infos;
};

export fn parseline(line: str) (texttype | void) = {
	return;
};

