use bunny::markdown;
use fmt;

fn print_medias() void = {
        let md = "[alt text](https://example.com) and ![alt text](https://images.com)";
        let links = markdown::extract_media(markdown::media::LINK, md);
        let images = markdown::extract_media(markdown::media::IMAGE, md);
        for (let link .. links) {
                fmt::printfln("alt={}, url={}", link.alt_text, link.url)!;  // should print 'alt=alt text, url=https://example.com'
        };
        for (let image .. images) {
                fmt::printfln("alt={}, url={}", image.alt_text, image.url)!;  // should print 'alt=alt text, url=https://images.com'
        };
};

export fn main() void = {
	print_medias();
};
