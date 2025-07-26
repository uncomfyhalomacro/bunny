use strings;

export type prop = struct {
	name: str,
	value: nullable *str,
};

export type htmlnode = struct {
	tag: nullable *str,
	props: []prop,
	isvoidable: bool,
	value: nullable *str,
	nodes: nullable *[]htmlnode
};

export fn tohtml(node: htmlnode) str = {
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
