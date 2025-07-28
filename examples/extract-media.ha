use bunny::markdown;
use fmt;
use strings;

fn print_medias() void = {
	let md = "[alt text](https://example.com) and another alt text but [image](https://url.to.image.com). and another [alt text with a lot of space    !](https://spaces.com). ![image ignored](https://uwu.com) and ![image alt text!](https://imgur.com) and another unpaired ![text](https://example.com ![followed by correct format](https://image.com/correct)";
        let links = markdown::extract_media(markdown::media::LINK, md);
        let images = markdown::extract_media(markdown::media::IMAGE, md);
        for (let link .. links) {
                fmt::printfln("start={}, end={}, alt={}, url={}, substring={}", link.start, link.end, link.alt_text, link.url, strings::sub(md, link.start, link.end))!;
        };
        for (let image .. images) {
                fmt::printfln("start={}, end={}, alt={}, url={}, substring={}", image.start, image.end, image.alt_text, image.url, strings::sub(md, image.start, image.end))!;
        };
};

export fn main() void = {
	print_medias();
};
