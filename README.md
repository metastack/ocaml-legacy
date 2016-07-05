# OCaml Legacy Building Patches for Windows

This repository contains patches necessary for compiling the native Windows versions of OCaml from 3.07 onwards.

Additionally, a couple of utility shell scripts are provided for doing bulk-builds and applying the patches. In order for these scripts to function correctly, the tarballs for the required version(s) of OCaml must be downloaded from [Inria](http://caml.inria.fr/pub/distrib) (and also the two official `.diffs` patch files for OCaml 3.07+1 and 3.07+2).

## Features

`config-option` (OCaml 3.07--3.08.4): back-ports the `-config` option added in 3.09.0. The patch is compatible with GPR465 and uses the identifier `config-option`.

The following relate to [GitHub Pull Requests](https://github.com/ocaml/ocaml/pulls) and [Mantis](http://caml.inria.fr/mantis) PRs:

[`GPR465`](https://github.com/ocaml/ocaml/pull/465) (OCaml 3.07--): adds a `patches` to the output of `ocamlc -config` for noting changes to the compiler. The patches themselves are from the pull request. The patch combines with the `config-option` patch to support 3.07 and 3.08 as well.

[`PR4575`](http://caml.inria.fr/mantis/view.php?id=4575) (OCaml 3.10.x): back-ports a fix to the output of `ocamlbuild -where` as a `\r` character was included in the output.

## Patches

The following patches address build system or environment changes which have occurred since these versions of OCaml were originally released:

`cc-profile` (OCaml 3.09.0--3.10.2): `CC_PROFILE` was not substituted when building `utils/config.ml` resulting in harmless, though invalid, output in `ocamlc -config`.

`mingw` (OCaml 3.07--3.12.1): `config/Makefile.mingw` used the old `-mno-cygin` method of invoking the MinGW version of GCC, which is no longer support in Cygwin.

`msvc` (OCaml 3.07--3.08.4): `config/Makefile.msvc` uses the Cygwin ld, nm and objcopy commands. This optional patch switches them to use the i686-w64-mingw32- prefixed versions instead.

`msvc64` (OCaml 3.10.x and 3.11.x): `config/Makefile.msvc` includes a library only required in the pre-release version of the 64-bit Windows SDK.

`ocamldoc-3.07` (OCaml 3.07): missing spaces in `ocamldoc/Makefile.nt` (it's actually not clear how this ever functioned, even in an old version of make!).

`ocamldoc-build` (OCaml 3.07--4.00.0): fixes a build system problem caused by a French accent in `ocamldoc/odoc_messages.ml` (the message was translated into English for OCaml 4.01.0 which eliminated the issue).

`tcl-tk-amd64` (OCaml 3.10.x--4.01.0): at the time of the release of 64-bit OCaml for Windows (using the Microsoft C Compiler for 3.10.0 and also GCC for 4.00.0) there was not a readily available 64-bit distribution of Tcl/Tk for Windows, so labltk was disabled for these ports. However, it has always worked and these patches enable the build system to build the 64-bit labltk for all versions.

The following patches relate to [Mantis](http://caml.inria.fr/mantis) PRs:

[`PR3485`](http://caml.inria.fr/mantis/view.php?id=3485) (OCaml 3.07--3.08.3): back-ports a Cygwin-related change made in OCaml 3.08.4.

[`PR4614`](http://caml.inria.fr/mantis/view.php?id=4614) (OCaml 3.07--3.10.x): back-ports commits [ad3ca0](https://github.com/ocaml/ocaml/commit/ad3ca0) and [ff88bb](https://github.com/ocaml/ocaml/commit/ff88bb) to allow building with Tcl/Tk 8.5 to OCaml 3.11.0 when support was officially added.

[`PR4700`](http://caml.inria.fr/mantis/view.php?id=4700) (OCaml 3.07--4.01.0): disables the tkanim library when building with Tcl/Tk 8.5 or later.

[`PR5011`](http://caml.inria.fr/mantis/view.php?id=5011) (OCaml 3.07--4.00.x): back-ports changes introduced in OCaml 4.01.0 to support Tcl/Tk 8.6.

## Copyright

`all.sh` and `build.sh` are copyright MetaStack Solutions Ltd., 2016 and distributed under the terms of the licence given at the top of each file.

Patches relating to PR3485, PR4614 and PR5011 (`PR3485.patch`, `PR4614.patch`, `PR5011.patch`, `PR5011-3.11.patch` and `PR5011-3.12+4.00.patch`) are back-ports of work already in the OCaml repository. The changes made in these patches are the copyrights of their respective authors and are distributed under the terms of the GNU Lesser Public Licence version 2.1 (see the file `LICENSE` in the [OCaml repository](https://github.com/ocaml/ocaml/blob/trunk/LICENSE)).

All other patches are the work of David Allsopp and are released under the [Creative Commons CC0 1.0 Universal licence](https://creativecommons.org/publicdomain/zero/1.0/).
