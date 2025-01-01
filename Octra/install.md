#### install lib
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Octra/env.sh
chmod +x env.sh
./env.sh
````
### config
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/Octra/config.ml
```

```
opam install ocamlfind cohttp-lwt-unix lwt_ppx
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
