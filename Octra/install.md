#### install lib
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Octra/env.sh
chmod +x env.sh
./env.sh
````
### config
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Octra/config.ml
```
```
ocamlfind ocamlopt -o config -thread -linkpkg -package yojson,cohttp-lwt-unix,unix,str,lwt_ppx config.ml
```
```
./config
```
