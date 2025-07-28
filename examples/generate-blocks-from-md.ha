use bunny::markdown;
use fmt;
use strings;

// TODO: This example shows that links with _ can be counted as italics. We need to add checks for the functions for that.
fn print_blocks() void = {
	let md = """
# Exploring the Wilderness 🏞️

Venturing into the *great outdoors* can be both **thrilling** and enlightening. Whether you're `hiking`, **camping**, or simply *observing nature*, there's always something new to discover.

![Mountain View](https://upload.wikimedia.org/wikipedia/commons/e/ec/Alpine_mountain_landscape.jpg)

A good adventurer knows how to pack essentials like a **map**, `compass`, and plenty of *water*. It's also wise to carry a `first-aid kit` and wear **comfortable shoes**.

When night falls, setting up a **tent** beneath the stars can be a magical experience.

![Starry Night](https://upload.wikimedia.org/wikipedia/commons/3/3f/Hubble_Ultra_Deep_Field_part_d.jpg)

Don't forget to record your journey in a *travel journal*. Share your story with others at [My Adventure Blog](https://example.com/adventure).

Stay safe, be *curious*, and keep exploring—because **the wild is waiting**!
""";
	let block_infos = markdown::generate_blocks(md);
	for (let blk .. block_infos) {
		let sinfos = markdown::generate_information_from_block(blk);
		if (len(sinfos) > 0) {
			fmt::printfln("-----------------------------------------")!;
			fmt::printfln("Unsorted!")!;
			fmt::printfln("-----------------------------------------")!;
		};
		for (let sinfo .. sinfos) {
			if (sinfo is markdown::media_info) {
				let sinfo = sinfo as markdown::media_info;
				fmt::printfln("start={}, end={}, alt={}, url={}, substring={}", sinfo.start, sinfo.end, sinfo.alt_text, sinfo.url, strings::sub(blk.block, sinfo.start, sinfo.end))!;
			};
			if (sinfo is markdown::pair_info) {
				let sinfo = sinfo as markdown::pair_info;
				fmt::printfln("start={}, end={}, text={}, substring={}", sinfo.start, sinfo.end, sinfo.text, strings::sub(blk.block, sinfo.start, sinfo.end))!;
			};
		};
		let sorted_sinfos = markdown::sort_infos_by_start_index(sinfos);
		if (len(sorted_sinfos) > 0) {
			fmt::printfln("-----------------------------------------")!;
			fmt::printfln("Sorted now!")!;
			fmt::printfln("-----------------------------------------")!;
		};
		for (let sorted_sinfo .. sorted_sinfos) {
			if (sorted_sinfo is markdown::media_info) {
				let sorted_sinfo = sorted_sinfo as markdown::media_info;
				fmt::printfln("start={}, end={}, alt={}, url={}, substring={}", sorted_sinfo.start, sorted_sinfo.end, sorted_sinfo.alt_text, sorted_sinfo.url, strings::sub(blk.block, sorted_sinfo.start, sorted_sinfo.end))!;
			};
			if (sorted_sinfo is markdown::pair_info) {
				let sorted_sinfo = sorted_sinfo as markdown::pair_info;
				fmt::printfln("start={}, end={}, text={}, substring={}", sorted_sinfo.start, sorted_sinfo.end, sorted_sinfo.text, strings::sub(blk.block, sorted_sinfo.start, sorted_sinfo.end))!;
			};
		};
	};
};
export fn main() void = {
	print_blocks();

};
