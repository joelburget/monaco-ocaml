let set_opt ~f obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.set obj name (f value)
;;

let set_opt_str obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Jstr.set obj name (Jstr.v value)
;;

let set_opt_bool obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Bool.set obj name value
;;

let set_opt_int obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Int.set obj name value
;;

let set_opt_float obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Float.set obj name value
;;

let set_opt_list ~f obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.set obj name (Jv.of_list f value)
;;

let set_opt_obj ~f =
  set_opt ~f:(fun value -> Jv.obj (value |> Array.of_list |> Array.map f))
;;

module type Variant_s = sig
  type t

  val to_string : t -> string
  val name : string
end

module Extend (Variant : Variant_s) = struct
  let set_opt obj =
    set_opt ~f:(fun value -> Jv.of_string (Variant.to_string value)) obj Variant.name
  ;;
end
