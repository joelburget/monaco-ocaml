open Helpers

type t = Jv.t

let new' () = Jv.new' (Jv.get (monaco ()) "Uri") [||]
let get_authority t = Jv.get t "authority"
let get_fragment t = Jv.get t "fragment"
let get_path t = Jv.get t "path"
let get_query t = Jv.get t "query"
let get_scheme t = Jv.get t "scheme"
let fs_path t = Jv.get t "fsPath"
let to_json t = Jv.call t "toJSON" [||]

let to_string ?skip_encoding t =
  let args = match skip_encoding with None -> [||] | Some b -> [| Jv.of_bool b |] in
  Jv.call t "toString" args
;;
