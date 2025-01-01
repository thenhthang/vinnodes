#### setup enviroment
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Octra/env.sh
chmod +x env.sh
./env.sh
````
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
opam install ocamlfind,cohttp-lwt-unix,lwt_ppx
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
