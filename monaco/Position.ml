type t =
  { line_number : int
  ; column : int
  }

let to_jv { line_number; column } =
  Jv.obj [| "lineNumber", Jv.of_int line_number; "column", Jv.of_int column |]
;;

let of_jv t =
  { line_number = Jv.get t "lineNumber" |> Jv.to_int
  ; column = Jv.get t "column" |> Jv.to_int
  }
;;
