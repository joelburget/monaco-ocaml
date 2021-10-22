module type Variant_s = sig
  type t

  val to_string : t -> string
  val name : string
end

module Extend (Variant : Variant_s) = struct
  let set_opt obj opt_val =
    match opt_val with
    | None -> ()
    | Some value -> Jv.Jstr.set obj Variant.name (Jstr.v (Variant.to_string value))
  ;;
end

let set_opt_str obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Jstr.set obj name (Jstr.v value)
;;

let set_opt_bool obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Bool.set obj name value
;;

let set_opt_int obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Int.set obj name value
;;
