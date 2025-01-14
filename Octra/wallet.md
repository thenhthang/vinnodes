### install dune
```
opam update
opam upgrade dune
opam install dune.3.17.0
eval $(opam env)
```
### genegate wallet
```
git clone https://github.com/octra-labs/wallet-gen.git
cd wallet-gen
eval $(opam env)
opam install . --deps-only --yes
dune build --profile release
dune exec ./bin/main.exe
```
