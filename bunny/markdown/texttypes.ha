use strings;
use fmt;

// A tagged union of [[mdpair::]] and [[media::]] as [[texttype::]].
export type texttype = (mdpair | media);

export type mdpair = enum {
	TEXT,  // Technically not a pair
	BOLD,
	INLINE_CODE,
	ITALIC,
};

// Represents an enum for either an image or a link.
export type media = enum {
	LINK,
	IMAGE
};

// A tagged union of [[media_info::]] and [[pair_info::]] for various textual
// information.
export type superinfotype = (media_info | pair_info);

// Represents the captured matches based on [[media::]]
// for images or links.
export type media_info = struct {
	start: size,
	end: size,
	alt_text: str,
	url: str,
	kind: media
};

// Represents the captured matches based on [[mdpair::]] for
// bold, inline code and italic text.
export type pair_info = struct {
	start: size,
	end: size,
	text: str,
	kind: mdpair
};

// Generates a list of [[media_info::]]s based on an [[media::]] enum variant from a line of text.
export fn extract_media(med: media, line: str) []media_info= {
	switch (med) {
		case media::LINK =>
			return _extract_linked_text(line);
		case media::IMAGE =>
			return _extract_image_text(line);
		case =>
			fmt::fatalf("Error: Unknown media type. Is this enum variant implemented?");
	};
};

// Generates a list of [[pair_info::]]s based on an [[mdpair::]] enum variant from a line of text.
export fn extract_text_from_pair(pair: mdpair, line: str) []pair_info = {
	switch (pair) {
		case mdpair::TEXT =>
			let new_pair_info = pair_info {
			start= 0z,
			end= len(line),
			text= line,
			kind= mdpair::TEXT
		};
			return [new_pair_info];
		case mdpair::INLINE_CODE =>
			return _extract_from_pair(line, '`');
		case mdpair::ITALIC =>
			return _extract_from_pair(line, '_');
		case mdpair::BOLD =>
			return _extract_doubled_pair(line, '*');
		case =>
			fmt::fatalf("Error: Unknown mdpair type. Is this enum variant implemented?");
	};
};

fn _get_kind_from_doubled_rune(p: rune) mdpair = {
	if (p == '*') {
		return mdpair::BOLD;
	};
	fmt::fatalf("Error: unimplemented!");
};


fn _extract_doubled_pair(line: str, p: rune) []pair_info = {
	let kind = _get_kind_from_doubled_rune(p);
	let pairs: []pair_info = [];
	let pair = pair_info {
		start= 0z,
		end= 0z,
		text= "",
		kind= kind
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
		if (r as rune == p) {
			r = strings::next(&iter);  // do it again
			if (r is done) {
				break;
			};
			index = index + 1;
			if (r as rune == p) {
				found_first_pair = true;
				if (found_count == 1) {
					pair.end = index; // a little offset to the left
					pair.text = strings::sub(line, pair.start + 2, pair.end - 2);
					append(pairs, pair)!;
					found_first_pair = false;
					found_count = 0;
				};
			};
		};
		if (found_first_pair) {
			pair.start = index - 2;
			found_count = found_count + 1;
			found_first_pair = false;
		};
	};
	return pairs;
};

fn _get_kind_from_rune(p: rune) mdpair = {
	if (p == '`') {
		return mdpair::INLINE_CODE;
	};
	if (p == '_') {
		return mdpair::ITALIC;
	};
	fmt::fatalf("Error: unimplemented!");
};

fn _extract_from_pair(line: str, p: rune) []pair_info = {
	let kind = _get_kind_from_rune(p);
	let pairs: []pair_info = [];
	let pair = pair_info {
		start= 0z,
		end= 0z,
		text= "",
		kind= kind
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
		if (r as rune == p) {
			found_first_pair = true;
			if (found_count == 1) {
				pair.end = index; // a little offset to the left
				pair.text = strings::sub(line, pair.start + 1, pair.end-1);
				append(pairs, pair)!;
				found_first_pair = false;
				found_count = 0;
			};
		};
		if (found_first_pair) {
			pair.start = index - 1;
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
		url= "",
		kind= media::LINK,
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
		if (r is done) {
			break;
		};
		index = index + 1;
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
				found_parenthesis_count = 0;
				continue;
			};  // else just go along..
		};

		if (r == '[') {
			found_first_bracket_pair = true;
			found_bracket_count += 1;
			if (found_bracket_count == 1) {
				info.start = index - 1;
			};
			for (r == '[') {
				r = strings::next(&iter);
				if (r is done) {
					break;
				};
				index = index + 1;
			};
		};

		if (r == ']') {
			if (found_first_bracket_pair) {
				for (r == ']') {
					r = strings::next(&iter);
					if (r is done) {
						break;
					};
					index = index + 1;
				};
				if (r == '(') {
					found_first_parenthesis_pair = true;
					found_parenthesis_count += 1;
					continue;
				};
			};
		};

		if (found_first_parenthesis_pair) {
			if (found_first_bracket_pair) {
				info.alt_text = strings::sub(line, info.start+1, index - 3);
				found_first_bracket_pair = false;
			};
			for (r != ')') {
				r = strings::next(&iter);
				if (r is done) {
					break;
				};
				index = index + 1;
				if (r == '(') {  // There should be only one
					found_first_bracket_pair = false;
					found_first_parenthesis_pair = false;
					found_bracket_count = 0;
					found_parenthesis_count = 0;
					break;
				};
			};
			if (r == ')') {
				for (r == ')') {
					r = strings::next(&iter);
					if (r is done) {
						break;
					};
					index = index + 1;
				};
			};
			info.end = index - 1;
			info.url = strings::sub(line, info.start + len(info.alt_text) + 3, info.end - 1);
			append(infos, info)!;
			found_first_bracket_pair = false;
			found_first_parenthesis_pair = false;
			found_bracket_count = 0;
			found_parenthesis_count = 0;
		};
	};
	return infos;
};

fn _extract_image_text(line: str) []media_info= {
	let infos: []media_info = [];
	let info = media_info {
		start= 0z,
		end= 0z,
		alt_text= "",
		url= "",
		kind= media::IMAGE
	};
	let ispairfound = false;
	let iter = strings::iter(line);
	let found_first_bracket_pair = false;
	let found_first_parenthesis_pair = false;
	let first_parens_count = 0z;
	let second_parens_count = 0z;
	let first_bracket_count = 0z;
	let second_bracket_count = 0z;
	let index = 0z;
	// TODO: implement regex checks for URL partition.
	for (true) {
		let r = strings::next(&iter);
		if (r is done) {
			break;
		};
		index += 1;
		if (!found_first_bracket_pair) {
			if (r == '!') {
				r = strings::next(&iter);
				if (r is done) {
					break;
				};
				index += 1;
				if (r == '[') {
					info.start = index - 2;
					found_first_bracket_pair = true;
					found_first_parenthesis_pair = false;
					first_bracket_count += 1;
				};
			};
		} else {
			for (r != ']') {
				r = strings::next(&iter);
				if (r is done) {
					break;
				};
				index += 1;
			};
			if (r is done) {
				break;
			};
			if (r == ']') {
				second_bracket_count += 1;
				for (r == ']') {
					r = strings::next(&iter);
					if (r is done) {
						break;
					};
					if (r == ']') {
						second_bracket_count += 1;
					};
					index += 1;
				};
			};
			if (r is done) {
				break;
			};
			if (first_bracket_count != second_bracket_count) {
				fmt::errorfln("Warning: found unbalanced brackets in image syntax! Review your content.")!;
			};
			if (r == '(') {
				found_first_parenthesis_pair = true;
				info.alt_text = strings::sub(line, info.start + 2, index - 2);
				first_parens_count += 1;
				for (r == '(') {
					r = strings::next(&iter);
					if (r is done) {
						break;
					};
					index += 1;
					if (r == '(') {
						first_parens_count += 1;
					};

				};
				if (r is done) {
					break;
				};
			};
			for (r != ')') {
				r = strings::next(&iter);
				if (r is done) {
					break;
				};
				index += 1;
				if (r == '!') {
					r = strings::next(&iter);
					if (r is done) {
						break;
					};
					index += 1;
					if (r == '[') {
						info.start = index - 2;
						found_first_bracket_pair = true;
						found_first_parenthesis_pair = false;
						first_bracket_count = 0;
						first_parens_count = 0;
						second_bracket_count = 0;
						second_parens_count = 0;
						break;
					};
				};
			};
			if (r is done) {
				break;
			};
			if (!found_first_parenthesis_pair) {
				continue;
			};
			if (r == ')') {
				second_parens_count += 1;
				for (let z = 1z; z < first_parens_count; z+=1) {
					r = strings::next(&iter);
					if (r is done) {
						found_first_parenthesis_pair = false;
						found_first_bracket_pair = false;
						first_parens_count = 0;
						second_parens_count = 0;
						fmt::errorfln("Warning: found unbalanced parentheses in image syntax! Review your content.")!;
						break;
					};
					index += 1;
					if (r == ')') {
						second_parens_count += 1;
					} else {
						found_first_parenthesis_pair = false;
						found_first_bracket_pair = false;
						first_parens_count = 0;
						second_parens_count = 0;
						fmt::errorfln("Warning: found unbalanced parentheses in image syntax! Review your content.")!;
						break;
					};
				};
				if (!found_first_parenthesis_pair && !found_first_bracket_pair) {
					continue;
				};
				if (second_parens_count == first_parens_count) {
					info.end = index;
					info.url = strings::sub(line, info.start + 2 + len(info.alt_text) + 2, info.end - 1);
					append(infos, info)!;
					second_parens_count = 0;
					first_parens_count =0;
					found_first_bracket_pair = false;
					found_first_parenthesis_pair = false;
				};
			};
		};
	};
	return infos;
};
