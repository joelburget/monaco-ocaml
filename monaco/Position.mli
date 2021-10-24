type t =
  { line_number : int
  ; column : int
  }

val to_jv : t -> Jv.t
val of_jv : Jv.t -> t
