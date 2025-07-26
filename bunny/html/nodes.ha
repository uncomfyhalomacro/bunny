use strings;
use os;
use fmt;

export type prop = struct {
	name: str,
	value: nullable *str,
};

export type parentnode = struct {
	tag: str,
	props: []prop,
	nodes: []htmlnodetype,
};

export type htmlnode = struct {
	tag: nullable *str,
	props: []prop,
	isvoidable: bool,
	value: nullable *str,
};

export type htmlnodetype = (parentnode | htmlnode);

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

export fn tohtml(node: htmlnodetype) str = {
	if (node is htmlnode) {
		return _htmlnode_tohtml(node as htmlnode);
	};
	if (node is parentnode) {
		return _parentnode_tohtml(node as parentnode);
	};
	fmt::fatalf("Error: unknown nodetype passed.");
};

export fn tohtmlattrs(attrs: []prop) []str = {
	let htmlattrs: []str = [];
	for (let attr .. attrs) {
		let new_attr: str = tohtmlattr(attr);
		append(htmlattrs, new_attr)!;
	};
	return htmlattrs;
};

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
