# monaco-ocaml

Ocaml bindings to Microsoft's [Monaco editor](https://microsoft.github.io/monaco-editor/) (the editing core of VS Code).

These bindings provide several types of customization, including:

* Creating declarative syntax highlighters, via [Monarch](https://microsoft.github.io/monaco-editor/monarch.html)
* Defining custom completion suggestions
* Defining new commands
* Defining keybindings and actions
* (soon) defining themes
* (soon) side-by-side and inline diff editors

This library implements a subset of the [Monaco API](https://microsoft.github.io/monaco-editor/api/index.html), aiming to implement more over time.
