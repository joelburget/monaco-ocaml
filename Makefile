format:
	@fd --extension ml --extension mli | xargs ocamlformat --enable-outside-detected-project --inplace

doc:
	@dune build @doc

lint:
	@opam-dune-lint
	@dune build @fmt
	@dune build @check @runtest

.PHONY: format doc lint
