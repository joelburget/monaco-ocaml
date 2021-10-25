# monaco-ocaml

Ocaml bindings to Microsoft's [Monaco editor](https://microsoft.github.io/monaco-editor/) (the editing core of VS Code).

These bindings provide several types of customization, including:

* Creating declarative syntax highlighters, via [Monarch](https://microsoft.github.io/monaco-editor/monarch.html)
* Defining custom completion suggestions
* Defining new commands
* Defining keybindings and actions
* (soon) defining themes
* (soon) side-by-side and inline diff editors

We build on the [brr](https://erratique.ch/software/brr/doc/index.html) library for browser interaction. In fact, brr is the only dependency (other than dune to build and odoc for building docs).

The bindings are intended to be low-level (quite close to the original JavaScript). There is probably room for a higher-level library written on top. In particular, it might be nice to use Lwt / Async rather than callbacks which are used here.

We implement only a subset of the [Monaco API](https://microsoft.github.io/monaco-editor/api/index.html), aiming to cover more over time. Please send a pull request if you need functionality we don't yet cover.
