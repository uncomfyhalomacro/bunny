use bunny::markdown;
use strings;
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
		assert(pair.start == 0, "start index is wrong!");
		assert(pair.end == 12, "end index is wrong!");
		assert(strings::sub(s, pair.start, pair.end) == "`code_block`", "Resulting text should be the substring!");
	};
};

@test fn more_inline_code() void = {
	let s = "`code_block` and `unpaired` but it is not actually paired with `s`";
	let text = markdown::mdpair::INLINE_CODE;
	let lpairs = markdown::extract_text_from_pair(text, s);
	let length = len(lpairs);
	for (let i = 0z; i < length; i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "code_block", "new text should be the extracted inline code!");
			assert(pair.start == 0, "start index is wrong!");
			assert(pair.end == 12, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "`code_block`", "Resulting text should be the substring!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "unpaired", "new text should be the extracted inline code!");
			assert(pair.start == 17, "start index is wrong!");
			assert(pair.end == 27, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "`unpaired`", "Resulting text should be the substring!");
		};
		if (i == 2) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "s", "new text should be the extracted inline code!");
			assert(pair.start == 63, "start index is wrong!");
			assert(pair.end == 66, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "`s`", "Resulting text should be the substring!");
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
		assert(pair.start == 0, "start index is wrong!");
		assert(pair.end == 17, "end index is wrong!");
		assert(strings::sub(s, pair.start, pair.end) == "_an italic text!_", "Resulting text should be the substring!");
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
			assert(pair.start == 0, "start index is wrong!");
			assert(pair.end == 17, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "_an italic text!_", "Resulting text should be the substring!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "followed by another in just an index away", "new text should be the extracted italic text!");
			assert(pair.start == 17, "start index is wrong!");
			assert(pair.end == 60, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "_followed by another in just an index away_", "Resulting text should be the substring!");
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
		assert(pair.start == 0, "start index is wrong!");
		assert(pair.end == 8, "end index is wrong!");
		assert("**bold**" == strings::sub(s, pair.start, pair.end), "Should be the text without the trimming!");
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
			assert(pair.start == 0, "start index is wrong!");
			assert(pair.end == 44, "end index is wrong!");
			assert("** this is a bold text with a space before**" == strings::sub(s, pair.start, pair.end), "Should be the text without the trimming!");
		};
		if (i == 1) {
			assert(pair.text != s, "original text and new text should not be the same!");
			assert(pair.text == "bold text", "new text should be the extracted bold text!");
			assert(pair.start == 66, "start index is wrong!");
			assert(pair.end == 79, "end index is wrong!");
			assert("**bold text**" == strings::sub(s, pair.start, pair.end), "Should be the text without the trimming!");
		};
	};
};

@test fn linked_text() void = {
	let s = "[this is an alt text](https://example.com) and this is not a correct [link text)";
	let text = markdown::media::LINK;
	let lpairs = markdown::extract_media(text, s);
	for (let pair .. lpairs) {
		assert(pair.alt_text != s, "original text and new text should not be the same!");
		assert(pair.alt_text == "this is an alt text", "new text should be extracted alt text!");
		assert(pair.url == "https://example.com", "new url should be extracted url!");
		assert(pair.start == 0, "start index is wrong!");
		assert(pair.end == 42, "end index is wrong!");
		assert(strings::sub(s, pair.start, pair.end) == "[this is an alt text](https://example.com)", "Resulting text should be the substring!");
	};
};

@test fn more_linked_text() void = {
	let s = "[alt text](https://example.com) and another alt text but [image](https://url.to.image.com). and another [alt text with a lot of space    !](https://spaces.com). ![image ignored](https://uwu.com)";
	let text = markdown::media::LINK;
	// start=0, end=31, alt=alt text, url=https://example.com, substring=[alt text](https://example.com)
	// start=57, end=90, alt=image, url=https://url.to.image.com, substring=[image](https://url.to.image.com)
	// start=104, end=159, alt=alt text with a lot of space    !, url=https://spaces.com, substring=[alt text with a lot of space    !](https://spaces.com)
	let lpairs = markdown::extract_media(text, s);
	for (let i = 0z; i < len(lpairs); i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.alt_text != s, "original text and new text should not be the same!");
			assert(pair.alt_text == "alt text", "new text should be extracted alt text!");
			assert(pair.url == "https://example.com", "new url should be extracted url!");
			assert(pair.start == 0, "start index is wrong!");
			assert(pair.end == 31, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "[alt text](https://example.com)", "Resulting text should be the substring!");
		};
		if (i == 1) {
			assert(pair.alt_text != s, "original text and new text should not be the same!");
			assert(pair.alt_text == "image", "new text should be extracted alt text!");
			assert(pair.url == "https://url.to.image.com", "new url should be extracted url!");
			assert(pair.start == 57, "start index is wrong!");
			assert(pair.end == 90, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "[image](https://url.to.image.com)", "Resulting text should be the substring!");
		};
		if (i == 2) {
			assert(pair.alt_text != s, "original text and new text should not be the same!");
			assert(pair.alt_text == "alt text with a lot of space    !", "new text should be extracted alt text!");
			assert(pair.url == "https://spaces.com", "new url should be extracted url!");
			assert(pair.start == 104, "start index is wrong!");
			assert(pair.end == 159, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "[alt text with a lot of space    !](https://spaces.com)", "Resulting text should be the substring!");
		};
	};
};

@test fn image_text() void = {
	let s="![image alt text!](https://imgur.com) and another unpaired ![text](https://example.com";
	let text = markdown::media::IMAGE;
	let lpairs = markdown::extract_media(text, s);
	for (let pair .. lpairs) {
		assert(pair.alt_text != s, "original text and new text should not be the same!");
		assert(pair.alt_text == "image alt text!", "new text should be extracted alt text!");
		assert(pair.url == "https://imgur.com", "new url should be extracted url!");
		assert(pair.start == 0, "start index is wrong!");
		assert(pair.end == 37, "end index is wrong!");
		assert(strings::sub(s, pair.start, pair.end) == "![image alt text!](https://imgur.com)", "resulting text should start after the first opening bracket and ends before the last closing parenthesis. the middle should be `](`!");
	};
};

@test fn more_image_text() void = {
	let s="![image alt text!](https://imgur.com) and another unpaired ![text](https://example.com ![followed by correct format](https://image.com/correct)";
	let text = markdown::media::IMAGE;
	let lpairs = markdown::extract_media(text, s);
	// 2 36 image alt text!](https://imgur.com			(0)
	// 89 142 followed by correct format](https://image.com/correct	(1)
	for (let i = 0z; i < len(lpairs); i+=1) {
		let pair = lpairs[i];
		if (i == 0) {
			assert(pair.alt_text != s, "original text and new text should not be the same!");
			assert(pair.alt_text == "image alt text!", "new text should be extracted alt text!");
			assert(pair.url == "https://imgur.com", "new url should be extracted url!");
			assert(pair.start == 0, "start index is wrong!");
			assert(pair.end == 37, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "![image alt text!](https://imgur.com)", "Resulting text should be the substring!");
		};
		if (i == 1) {
			assert(pair.alt_text != s, "original text and new text should not be the same!");
			assert(pair.alt_text == "followed by correct format", "new text should be extracted alt text!");
			assert(pair.url == "https://image.com/correct", "new url should be extracted url!");
			assert(pair.start == 87, "start index is wrong!");
			assert(pair.end == 143, "end index is wrong!");
			assert(strings::sub(s, pair.start, pair.end) == "![followed by correct format](https://image.com/correct)", "Resulting text should be the substring!");
		};
	};
};
