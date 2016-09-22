# OCaml Legacy Building Patches for Windows

This repository contains patches necessary for compiling the native Windows versions of OCaml from 3.07 onwards.

Additionally, a couple of utility shell scripts are provided for doing bulk-builds and applying the patches. In order for these scripts to function correctly, the tarballs for the required version(s) of OCaml must be downloaded from [Inria](http://caml.inria.fr/pub/distrib) (and also the two official `.diffs` patch files for OCaml 3.07+1 and 3.07+2).

## Features

`config-option` (OCaml 3.07--3.08.4): back-ports the `-config` option added in 3.09.0. The patch is compatible with GPR465 and uses the identifier `config-option`.

`win32-graph` (OCaml 3.08.4): back-ports commit [7a7a87](https://github.com/ocaml/ocaml/commit/7a7a87) from 3.09.0, fixing the graphics library for Windows.

The following relate to [GitHub Pull Requests](https://github.com/ocaml/ocaml/pulls) and [Mantis](http://caml.inria.fr/mantis) PRs:

[`GPR465`](https://github.com/ocaml/ocaml/pull/465) (OCaml 3.07--): adds a `patches` to the output of `ocamlc -config` for noting changes to the compiler. The patches themselves are from the pull request. The patch combines with the `config-option` patch to support 3.07 and 3.08 as well.

[`GPR582`](https://github.com/ocaml/ocaml/pull/582) (OCaml 4.03.0): back-ports [cfb03b](https://github.com/ocaml/ocaml/commit/cfb03b)  fixing installation of `.cmx` files for the `systhreads` library.

[`GPR658`](https://github.com/ocaml/ocaml/pull/658) (OCaml 3.07--): ensures that paths are always displayed using backslashes (from `ocamlc -config`, `camlp4 -where` and `ocamlbuild -where`).

[`GPR678`](https://github.com/ocaml/ocaml/pull/678) (OCaml 3.08.0--): correctly fixes [`PR3963`](http://caml.inria.fr/mantis/view.php?id=3963) which, for 4.01.0 onwards means that `Graphics.close_graph` doesn't crash the 64-bit runtime and for all versions means that calls to `Graphics.wait_next_event` are unblocked by closing the graphics Window.

[`PR4575`](http://caml.inria.fr/mantis/view.php?id=4575) (OCaml 3.10.x): back-ports a fix to the output of `ocamlbuild -where` as a `\r` character was included in the output.

[`PR4683`](http://caml.inria.fr/mantis/view.php?id=4683) (OCaml 3.11.x): back-ports commit [27e0b7](https://github.com/ocaml/ocaml/commit/27e0b7) from 3.12.0 installing labltk.bat instead of a bash script.

[`PR4847`](http://caml.inria.fr/mantis/view.pho?id=4847) (OCaml 3.10.0--3.11.1): back-ports commits [f98e29](https://github.com/ocaml/ocaml/commit/f98e29) and [a795c5](https://github.com/ocaml/ocaml/commit/a795c5) to `ocamlc -output-obj` for msvc64.

[`PR5331`](http://caml.inria.fr/mantis/view.pho?id=5331) (OCaml 3.12.1): back-ports commit [6b6e39](https://github.com/ocaml/ocaml/commit/6b6e39) fixing the installation of ocamlmktop without the .exe extension on Windows.

[`PR6766`](http://caml.inria.fr/mantis/view.pho?id=6766) (OCaml 3.12.0--4.02.3): back-ports commit [b014f2](https://github.com/ocaml/ocaml/commit/b014f2) fixing an intermittent crash when using systhreads.

[`PR6797`](http://caml.inria.fr/mantis/view.pho?id=6766) (OCaml 4.02.2--4.02.3): back-ports commit [44b8b5](https://github.com/ocaml/ocaml/commit/44b8b5) fixing the -output-complete-obj option for the Microsoft C compiler ports.

## Patches

The following patches address build system or environment changes which have occurred since these versions of OCaml were originally released:

`cc-profile` (OCaml 3.07--3.10.2): `CC_PROFILE` was not substituted when building `utils/config.ml` resulting in harmless, though invalid, output in `ocamlc -config`.

`debugtype` (OCaml 3.07--3.09.3): back-ports commits [ac86cc](https://github.com/ocaml/ocaml/commit/ac86cc) and [536dfe](https://github.com/ocaml/ocaml/commit/536dfe) to remove the `/debugtype:cv` which ceased to be support in Visual Studio .NET 2002.

`mingw` (OCaml 3.07--3.12.1): `config/Makefile.mingw` used the old `-mno-cygin` method of invoking the MinGW version of GCC, which is no longer support in Cygwin.

`msvc` (OCaml 3.07--3.08.4): `config/Makefile.msvc` uses the Cygwin ld, nm and objcopy commands. This optional patch switches them to use the i686-w64-mingw32- prefixed versions instead.

`msvc64` (OCaml 3.10.x and 3.11.x): `config/Makefile.msvc` includes a library only required in the pre-release version of the 64-bit Windows SDK.

`ocamldoc-3.07` (OCaml 3.07): missing spaces in `ocamldoc/Makefile.nt` (it's actually not clear how this ever functioned, even in an old version of make!).

`ocamldoc-build` (OCaml 3.07--4.00.1): fixes a build system problem caused by various French accents in `ocamldoc` (a concerted effort was made to eliminate encoding problems prior to OCaml 4.01.0).

`output-obj` (OCaml 3.07): back-ports a small part of [e2b313](https://github.com/ocaml/ocaml/commit/e2b313) which suppresses a warning emitted by GCC for `ocamlc -output-obj`

`tcl-tk-amd64` (OCaml 3.10.x--4.01.0): at the time of the release of 64-bit OCaml for Windows (using the Microsoft C Compiler for 3.10.0 and also GCC for 4.00.0) there was not a readily available 64-bit distribution of Tcl/Tk for Windows, so labltk was disabled for these ports. However, it has always worked and these patches enable the build system to build the 64-bit labltk for all versions.

`win-runtime` (OCaml 3.11.0--4.02.1): back-ports commit [615472](https://github.com/ocaml/ocaml/commit/615472) which fixes the output filename when compiling the debug runtime.

The following patches relate to [Mantis](http://caml.inria.fr/mantis) PRs:

[`PR3485`](http://caml.inria.fr/mantis/view.php?id=3485) (OCaml 3.07--3.08.2): back-ports a Cygwin-related change made in OCaml 3.08.3.

[`PR4483`](http://caml.inria.fr/mantis/view.php?id=4483) (OCaml 3.10.1): back-ports commit [fd07b4](https://github.com/ocaml/ocaml/commit/fd07b4) from OCaml 3.10.2 converting `byterun/finalise.c` back to ANSI C.

[`PR4614`](http://caml.inria.fr/mantis/view.php?id=4614) (OCaml 3.07--3.10.x): back-ports commits [ad3ca0](https://github.com/ocaml/ocaml/commit/ad3ca0) and [ff88bb](https://github.com/ocaml/ocaml/commit/ff88bb) to allow building with Tcl/Tk 8.5 to OCaml 3.11.0 when support was officially added.

[`PR4700`](http://caml.inria.fr/mantis/view.php?id=4700) (OCaml 3.07--4.01.0): disables the tkanim library when building with Tcl/Tk 8.5 or later.

[`PR5011`](http://caml.inria.fr/mantis/view.php?id=5011) (OCaml 3.07--4.00.x): back-ports changes introduced in OCaml 4.01.0 to support Tcl/Tk 8.6.

## Copyright

`all.sh` and `build.sh` are copyright MetaStack Solutions Ltd., 2016 and distributed under the terms of the licence given at the top of each file.

Patches above described as back-ports represent work already in the OCaml repository. The changes made in these patches are the copyrights of their respective authors and are distributed under the terms of the GNU Lesser Public Licence version 2.1 (see the file `LICENSE` in the [OCaml repository](https://github.com/ocaml/ocaml/blob/trunk/LICENSE)).

All other patches are the work of David Allsopp and are released under the [Creative Commons CC0 1.0 Universal licence](https://creativecommons.org/publicdomain/zero/1.0/).
