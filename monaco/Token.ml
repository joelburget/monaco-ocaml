open Helpers

type t = Jv.t

let new' offset type' language =
  Jv.new'
    (Jv.get (monaco ()) "Token")
    [| Jv.of_int offset; Jv.of_string type'; Jv.of_string language |]
;;

let get_language t = Jv.get t "language"
let get_offset t = Jv.get t "offset"
let get_type t = Jv.get t "type"
let to_string t = Jv.call t "toString" [||]
