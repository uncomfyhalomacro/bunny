use bunny::html;
use strings;
use os;
use fmt;

export const BUNNY_VERSION = "0.1.0";

export fn main() void = {
	let new_prop = html::prop {
		name = "href",
		value = "https://example.com",
	};
	let second_prop = html::prop {
		name = "rel",
		value = "me",
	};
	let third_prop = html::prop {
		name = "xcom",
		value = void,
	};
	let new_node = html::htmlnode {
		tag = "a",
		props = [new_prop, second_prop, third_prop],
		isvoidable = false,
		value = "Hello, world!",
	};
	let html = html::tohtml(new_node);
	defer free(html);
	fmt::printfln(html)!;
};
