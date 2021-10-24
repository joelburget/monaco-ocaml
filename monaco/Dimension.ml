type t =
  { height : int
  ; width : int
  }

let to_jv { height; width } =
  Jv.obj [| "height", Jv.of_int height; "width", Jv.of_int width |]
;;
