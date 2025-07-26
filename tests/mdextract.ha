use bunny::markdown;
use fmt;

@test fn normaltext() void = {
	let s = "normal text indeed!";
	let text = markdown::mdpair::TEXT;
	let lpairs = markdown::extract_text_from_pair(text, s);
	for (let pair .. lpairs) {
		assert(pair.text == s, "original text and new text should be the same!");
		assert(pair.start == 0, "index should stay at 0");
		assert(pair.end == len(pair.text) && pair.end == len(s), "the end index should be just the length!");
	};
};

@test fn inlinecode() void = {
	let s = "`code_block` and `unpaired";
	let text = markdown::mdpair::INLINE_CODE;
	let lpairs = markdown::extract_text_from_pair(text, s);
	for (let pair .. lpairs) {
		assert(pair.text != s, "original text and new text should not be the same!");
		assert(pair.text == "code_block", "new text should be the extracted inline code!");
		assert(pair.start == 1, "start index is wrong!");
		assert(pair.end == 11, "end index is wrong!");
	};
};

@test fn more_inline_code() void = {
	let s = "`code_block` and `unpaired` but it is not actually paired with `s`";
	let text = markdown::mdpair::INLINE_CODE;
	let lpairs = markdown::extract_text_from_pair(text, s);
	let length = len(lpairs);
	// start=1, end=11, text=code_block  (0)
	// start=18, end=26, text=unpaired   (1)
	// start=64, end=65, text=s          (2)
	for (let i = 0z; i < length; i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "code_block", "new text should be the extracted inline code!");
			assert(pair.start == 1, "start index is wrong!");
			assert(pair.end == 11, "end index is wrong!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "unpaired", "new text should be the extracted inline code!");
			assert(pair.start == 18, "start index is wrong!");
			assert(pair.end == 26, "end index is wrong!");
		};
		if (i == 2) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "s", "new text should be the extracted inline code!");
			assert(pair.start == 64, "start index is wrong!");
			assert(pair.end == 65, "end index is wrong!");
		};
	};
};

@test fn italic_text() void = {
	let s = "_an italic text!_ and _unpaired";
	let text = markdown::mdpair::ITALIC;
	let lpairs = markdown::extract_text_from_pair(text, s);
	for (let pair .. lpairs) {
		assert(pair.text != s, "original text and new text should not be the same!");
		assert(pair.text == "an italic text!", "new text should be the extracted italic text!");
		assert(pair.start == 1, "start index is wrong!");
		assert(pair.end == 16, "end index is wrong!");
	};
};

@test fn more_italic_text() void = {
	let s = "_an italic text!__followed by another in just an index away_ then an unpaired_!";
	let text = markdown::mdpair::ITALIC;
	let lpairs = markdown::extract_text_from_pair(text, s);
	let length = len(lpairs);
	// 1, 16, an italic text!				(0)
	// 18, 59, followed by another in just an index away	(1)
	for (let i = 0z; i < length; i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "an italic text!", "new text should be the extracted italic text!");
			assert(pair.start == 1, "start index is wrong!");
			assert(pair.end == 16, "end index is wrong!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "followed by another in just an index away", "new text should be the extracted italic text!");
			assert(pair.start == 18, "start index is wrong!");
			assert(pair.end == 59, "end index is wrong!");
		};
	};

};

@test fn bold_text() void = {
	let s = "**bold** text and unpaired** text.";
	let text = markdown::mdpair::BOLD;
	let lpairs = markdown::extract_text_from_pair(text, s);
	for (let pair .. lpairs) {
		assert(pair.text != s, "original text and new text should not be the same!");
		assert(pair.text == "bold", "new text should be the extracted bold text!");
		assert(pair.start == 2, "start index is wrong!");
		assert(pair.end == 6, "end index is wrong!");
	};
};

@test fn more_bold_text() void = {
	let s = "** this is a bold text with a space before**, but this is another **bold text**. This one is **unpaired.";
	let text = markdown::mdpair::BOLD;
	let lpairs = markdown::extract_text_from_pair(text, s);
	// 2 42  this is a bold text with a space before	(0)
	// 68 77 bold text					(1)
	let length = len(lpairs);
	for (let i = 0z; i < length; i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == " this is a bold text with a space before", "new text should be the extracted bold text!");
			assert(pair.start == 2, "start index is wrong!");
			assert(pair.end == 42, "end index is wrong!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "bold text", "new text should be the extracted bold text!");
			assert(pair.start == 68, "start index is wrong!");
			assert(pair.end == 77, "end index is wrong!");
		};
	};
};
