use bunny::html;

@test fn helloworld_a_tag() void = {
	let new_prop = html::prop {
		name = "href",
		value = &"https://example.com",
	};
	let second_prop = html::prop {
		name = "rel",
		value = &"me",
	};
	let third_prop = html::prop {
		name = "xcom",
		value = null,
	};
	let new_node = html::htmlnode {
		tag = &"a",
		props = [new_prop, second_prop, third_prop],
		isvoidable = false,
		value = &"Hello, world!",
		nodes = [],
	};
	let html = html::tohtml(new_node);
	assert(
		```<a href="https://example.com" rel="me" xcom>Hello, world!</a>``` == html,
		"The generated HTML is not equal"
	);

};
