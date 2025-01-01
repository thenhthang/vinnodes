#### setup enviroment
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Octra/env.sh
chmod +x env.sh
./env.sh
````
```
wget https://raw.githubusercontent.com/0xChicharito/Octra/refs/heads/main/config.ml
```

```
eval $(opam env)
```

```
opam switch show
```

```
opam switch list
```

```
opam switch set <switch_name>
```

```
eval $(opam env)
```

```
opam install ocamlfind
```

```
opam reinstall yojson
```

```
ocamlfind ocamlopt -o config -thread -linkpkg -package yojson,cohttp-lwt-unix,unix,str,lwt_ppx config.ml
```

```
./config
```
