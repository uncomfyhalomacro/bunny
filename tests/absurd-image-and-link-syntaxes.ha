use bunny::markdown;
use strings;
use fmt;

@test fn too_many_pairs_links() void = {
	let line = "[[alt text]]((https://example.com)) [real link that makes sense](https://example.com)";
	let links= markdown::extract_media(markdown::media::LINK, line);
	assert(len(links) == 2);
	for (let link .. links) {
        fmt::printfln("start={}, end={}, alt={}, url={}, substring={}", link.start, link.end, link.alt_text, link.url, strings::sub(line, link.start, link.end))!;
	};
};

@test fn too_many_pairs_images() void = {
	let line = "![[alt text]]((https://example.com) ![real link that makes sense](https://example.com)";
	let links= markdown::extract_media(markdown::media::IMAGE, line);
	assert(len(links) == 1);
	for (let link .. links) {
        	assert(link.start == 36);
        	assert(link.end == 86);
        	assert(link.url == "https://example.com");
        	assert(strings::sub(line, link.start, link.end) == "![real link that makes sense](https://example.com)");
	};
};


