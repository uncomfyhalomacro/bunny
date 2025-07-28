use fmt;

// This generates the necessary list of [[superinfotype::]]s from a block of text.
// Do note that this is unsorted so you have to call [[sort_infos_by_start_index::]]
// and then check for overlaps. Overlaps may indicate invalid markdown syntax or nested markdown syntax and should
// not be rendered as much as possible.
//
// Do also note that [[mdpair::TEXT::]] was not included in the generation of info types because
// 1. it's a placeholder in [[mdpair::]].
// 2. we have start and end indices to indicate which parts of a text is just plain text.
//
// TODO: Create a filter for overlaps. Check the end index of the previous item and check the
// start index of the next item and so on...
export fn generate_information_from_block(blk: block_info) []superinfotype= {
	let supinfos: []superinfotype = [];
	let textblock = blk.block;
	// TODO: add normalise block here.
	// NOTE: our base case should be mdpair::TEXT. That means if len(supinfos) == 0, it should just be text.
	let links = extract_media(media::LINK, textblock);
	let images = extract_media(media::IMAGE, textblock);
	let bold_texts = extract_text_from_pair(mdpair::BOLD, textblock);
	let italic_texts = extract_text_from_pair(mdpair::ITALIC, textblock);
	let inline_codes = extract_text_from_pair(mdpair::INLINE_CODE, textblock);
	for (let link .. links) {
		append(supinfos, link)!;
	};
	for (let image .. images) {
		append(supinfos, image)!;
	};
	for (let bold_text .. bold_texts) {
		append(supinfos, bold_text)!;
	};
	for (let italic_text .. italic_texts) {
		append(supinfos, italic_text)!;
	};
	for (let inline_code .. inline_codes) {
		append(supinfos, inline_code)!;
	};
	return supinfos;
};

// A binary based search function to find the position
// to be inserted into a list of supertypes. Used for binary sorting.
fn _binary_search_infos(ssts: []superinfotype, item: superinfotype, low: size, high: size) size = {
	if (high <= low) {
		if (get_start_index_from_superinfotype(item) > get_start_index_from_superinfotype(ssts[low])) {
			return low + 1;
		} else {
			return low;
		};
	};

	let mid: size = (low + high) / 2;

	if (get_start_index_from_superinfotype(item) == get_start_index_from_superinfotype(ssts[mid])) {
		return mid + 1;
	};

	if (get_start_index_from_superinfotype(item) > get_start_index_from_superinfotype(ssts[mid])) {
		return _binary_search_infos(ssts, item, mid+1, high);
	};
	return _binary_search_infos(ssts, item, low, mid - 1);
};

// Sorts a list of [[supertypes::]] using a binary search insert sort.
// The sorting is based on the value of the start field of one of its
// subtypes, [[media_info::]] and [[pair_info::]].
export fn sort_infos_by_start_index(ssts: []superinfotype) []superinfotype = {
	for (let i = 1z; i < len(ssts); i+=1) {
		let item = ssts[i];
		let j = _binary_search_infos(ssts, item, 0, i-1);
		let tmp_arr: []superinfotype = [];
		for (let z = 0z; z < j; z+=1) {
			append(tmp_arr, ssts[z])!;
		};
		append(tmp_arr, item)!;
		for (let b = j; b < i; b+=1) {
			append(tmp_arr, ssts[b])!;
		};
		for (let d = i + 1; d < len(ssts); d+=1) {
			append(tmp_arr, ssts[d])!;
		};
		ssts = tmp_arr;
	};
	return ssts;

};

export fn get_start_index_from_superinfotype(st: superinfotype) size = {
	match (st) {
		case let new_info: media_info =>
			return _get_start_index_from_media_info(new_info);
		case let new_info: pair_info =>
			return _get_start_index_from_pair_info(new_info);
		case =>
			fmt::fatalf("Error: one or more subtypes don't have the same implementation yet!");
	};
};

export fn get_end_index_from_superinfotype(st: superinfotype) size = {
	if (st is media_info) {
		return _get_end_index_from_media_info(st as media_info);
	};
	if (st is pair_info) {
		return _get_end_index_from_pair_info(st as pair_info);
	};
	fmt::fatalf("Error: one or more subtypes don't have the same implementation yet!");
};

fn _get_start_index_from_media_info(st: media_info) size = {
	return st.start;
};

fn _get_start_index_from_pair_info(st: pair_info) size = {
	return st.start;
};

fn _get_end_index_from_media_info(st: media_info) size = {
	return st.end;
};

fn _get_end_index_from_pair_info(st: pair_info) size = {
	return st.end;
};

