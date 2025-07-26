use bunny::html;
use fmt;

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
	};
	let html = html::tohtml(new_node);
	assert(
		```<a href="https://example.com" rel="me" xcom>Hello, world!</a>``` == html,
		"The generated HTML is not equal"
	);

};

@test fn helloworld_inside_a_div() void = {
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
	};
	let parent = html::parentnode {
		tag = "div",
		nodes = [new_node],
		props = []
	};
	let html = html::tohtml(parent);
	assert(
		```<div><a href="https://example.com" rel="me" xcom>Hello, world!</a></div>``` == html,
		"The generated HTML is not equal"
	);
};

@test fn helloworld_inside_a_div_inside_another_div() void = {
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
	};
	let parent = html::parentnode {
		tag = "div",
		nodes = [new_node],
		props = []
	};
	let grandparent = html::parentnode {
		tag = "div",
		nodes = [parent],
		props = []
	};
	let html = html::tohtml(grandparent);
	fmt::printfln(html)!;
	assert(
		```<div><div><a href="https://example.com" rel="me" xcom>Hello, world!</a></div></div>``` == html,
		"The generated HTML is not equal"
	);
};

