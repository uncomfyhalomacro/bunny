use bunny::markdown;
use fmt;
use strings;

fn print_bold() void = {
	let source = "** this is a bold text with a space before**, but this is another **bold text**. This one is **unpaired.";
	let bold_texts = markdown::extract_text_from_pair(markdown::mdpair::BOLD, source);
	for (let b .. bold_texts) {
		fmt::printfln("start={}, end={}, text={}, substring={}", b.start, b.end, b.text, strings::sub(source, b.start, b.end))!;

	};
};

export fn main() void = {
	print_bold();
};
