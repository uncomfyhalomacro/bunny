use strings;
use os;
use fmt;

// Passed to [[bunny::html::parentnode]] and [[bunny::html::htmlnode]], the [[bunny::html::htmlnodesupertype]].
// They are actually generated for HTML attributes such as
// `rel` or `src`.
export type prop = struct {
	name: str,
	value: nullable *str,
};

// A parent node is a node that must always hold a tag
// and may contain child nodes of [[bunny::html::htmlnodesupertype]].
// Optionally, it can also hold a list of [[bunny::html::prop]]s.
// It's similar to [[bunny::html::htmlnode]] in a sense that
// both holds tags and props. Useful for generating HTML elements.
export type parentnode = struct {
	tag: str,
	props: []prop,
	nodes: []htmlnodesupertype,
};

// A type representing an HTML node, useful for generating
// HTML elements.
export type htmlnode = struct {
	tag: nullable *str,
	props: []prop,
	isvoidable: bool,
	value: nullable *str,
};

// A tagged union type of HTML node types.
export type htmlnodesupertype = (parentnode | htmlnode);

fn _parentnode_tohtml(pnode: parentnode) str = {
	if (strings::trim(pnode.tag) == "") {
		fmt::fatalf("Error: a parent node should have a tag.");
	};
	let htmlattrs = tohtmlattrs(pnode.props);
	let innerhtml = "";
	if (len(htmlattrs) > 0) {
		innerhtml = strings::concat(innerhtml, strings::join(" ", htmlattrs...)!)!;
		innerhtml = strings::trim(innerhtml);
	};
	let inlinehtml = strings::concat("<", pnode.tag)!;
	inlinehtml = strings::concat(inlinehtml, " ")!;
	inlinehtml = strings::concat(inlinehtml, innerhtml)!;
	inlinehtml = strings::trim(inlinehtml);
	inlinehtml = strings::concat(inlinehtml, ">")!;
	if (len(pnode.nodes) > 0) {
		for (let childnode .. pnode.nodes) {
			inlinehtml = strings::concat(inlinehtml, tohtml(childnode))!;
		};
	};
	inlinehtml = strings::concat(inlinehtml, "</")!;
	inlinehtml = strings::concat(inlinehtml, pnode.tag)!;
	inlinehtml = strings::concat(inlinehtml, ">")!;
	return inlinehtml;
};

fn _htmlnode_tohtml(node: htmlnode) str = {
	let tag: str = match (node.tag) {
	case null =>
		match(node.value) {
		case null =>
			return "";
		case let value: *str =>
		return *value;
		};
	case let tag: *str =>
		yield *tag;
	};
	let value: str = match(node.value) {
		case null =>
			yield "";
		case let value: *str =>
		yield *value;
	};
	let htmlattrs = tohtmlattrs(node.props);
	let innerhtml = "";
	if (len(htmlattrs) > 0) {
		innerhtml = strings::concat(innerhtml, strings::join(" ", htmlattrs...)!)!;
		innerhtml = strings::trim(innerhtml);
	};
	let inlinehtml = strings::concat("<", tag)!;
	inlinehtml = strings::concat(inlinehtml, " ")!;
	inlinehtml = strings::concat(inlinehtml, innerhtml)!;
	inlinehtml = strings::trim(inlinehtml);
	inlinehtml = strings::concat(inlinehtml, ">")!;
	if (node.isvoidable) {
		return inlinehtml;  // the value inside is ignored and not concatenated.
	};
	inlinehtml = strings::concat(inlinehtml, value)!;
	inlinehtml = strings::concat(inlinehtml, "</")!;
	inlinehtml = strings::concat(inlinehtml, tag)!;
	inlinehtml = strings::concat(inlinehtml, ">")!;
	return inlinehtml;
};

// Generates HTML elements as string from [[bunny::html::parentnode]] or [[bunny::html::htmlnode]].
export fn tohtml(node: htmlnodesupertype) str = {
	match (node) {
		case let new_node: htmlnode =>
			return _htmlnode_tohtml(node as htmlnode);
		case let new_node: parentnode =>
			return _parentnode_tohtml(node as parentnode);
		case =>
			fmt::fatalf("Error: unknown nodetype passed.");
	};
};

// Generates HTML attributes from a list of [[bunny::html::prop]] as a
// list of string equivalents.
export fn tohtmlattrs(attrs: []prop) []str = {
	let htmlattrs: []str = [];
	for (let attr .. attrs) {
		let new_attr: str = tohtmlattr(attr);
		append(htmlattrs, new_attr)!;
	};
	return htmlattrs;
};

// Generates an HTML attribute from a [[bunny::html::prop]] to its string equivalent.
export fn tohtmlattr(attr: prop) str = {
	let name = attr.name;
	let value: str = match(attr.value) {
	case null =>
		yield "";
	case let value: *str =>
		let tmp = strings::concat("=\"", *value)!;
		tmp = strings::concat(tmp, "\"")!;
		yield tmp;
	};
	let htmlattr = strings::concat(name, value)!;
	return htmlattr;
};
