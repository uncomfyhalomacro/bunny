use bunny::html;
use strings;
use os;
use fmt;

export const BUNNY_VERSION = "0.1.0";
export const MAX_ARGS_LENGTH: size = 3;

export fn print_help() void = {
	let usage =
```Usage:
	bunny [OPTIONS...] <subcommand> [SUBCOMMAND OPTIONS...]

Help Options:
	-h, --help		Shows help options

Application Subcommands:
	 b, build		Deletes the output directory if there is one and builds the site
	 s, serve		Serves the site

Build Subcommand Options:
	-h, --help		Shows help options for the build subcommand
	-w, --watch		Enables watcher mode. Rebuilds the site if it detects file
				changes in the content directory

Serve Subcommand Options:
	-h, --help		Shows help options for the build subcommand
	-w, --watch		Enables watcher mode. Rebuilds the site if it detects file
				changes in the content directory
```;
fmt::printfln(usage)!;
};

export fn main() void = {
	if (len(os::args) == 1) {
		fmt::errorfln("Please provide a summary and additional arguments. For more help, run `bunny -h`")!;
		os::exit(2);
	};

	if (len(os::args) > MAX_ARGS_LENGTH) {
		fmt::errorfln("Too many arguments. For more help, run `bunny -h`")!;
		os::exit(2);
	};

	let arg_i = 1z;
	let subcommand = "";
	let run_help_for_subcommand = false;
	for (arg_i < len(os::args); arg_i += 1) {
		if ((os::args[arg_i] == "-h" || os::args[arg_i] == "--help") && arg_i == 1) {
			print_help();
			os::exit(0);
		};
		if ((os::args[arg_i] == "s" || os::args[arg_i] == "serve") && arg_i == 1) {
			subcommand = os::args[arg_i];
		};
		if ((os::args[arg_i] == "-h" || os::args[arg_i] == "--help")) {
			if (os::args[arg_i - 1] == subcommand) {
				run_help_for_subcommand = true;
			};
		};
	};
	if (run_help_for_subcommand) {
		fmt::printfln("Help for {}.", subcommand)!;
		os::exit(0);
	};
	if (subcommand != "") {
		fmt::printfln("Running {} command.", subcommand)!;
	} else {
		print_help();
	};
};
