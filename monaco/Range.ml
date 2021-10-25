open Helpers

type t = Jv.t

let to_jv x = x
let of_jv x = x

(*
type t =
  { end_column : int
  ; end_line_number : int
  ; start_column : int
  ; start_line_number : int
  }

let to_jv { end_column; end_line_number; start_column; start_line_number } =
  Jv.new'
    (Jv.get (monaco ()) "Range")
    [| Jv.of_int start_line_number
     ; Jv.of_int start_column
     ; Jv.of_int end_line_number
     ; Jv.of_int end_column
    |]
;;
   *)

let collapse_to_start t = Jv.call t "collapseToStart" [||]

let contains_position t pos =
  Jv.call t "containsPosition" [| Position.to_jv pos |] |> Jv.to_bool
;;

let contains_range t range = Jv.call t "containsRange" [| range |] |> Jv.to_bool
let equals_range t range = Jv.call t "equalsRange" [| range |] |> Jv.to_bool
let get_end_position t = Jv.call t "getEndPosition" [||] |> Position.of_jv
let get_start_position t = Jv.call t "getStartPosition" [||] |> Position.of_jv
let intersect_ranges t range = Jv.call t "intersectRanges" [| range |]
let is_empty t = Jv.call t "isEmpty" [||] |> Jv.to_bool
let plus_range t range = Jv.call t "plusRange" [| range |]

let set_end_position t end_line_number end_column =
  Jv.call t "setEndPosition" [| Jv.of_int end_line_number; Jv.of_int end_column |]
;;

let set_start_position t start_line_number start_column =
  Jv.call t "setStartPosition" [| Jv.of_int start_line_number; Jv.of_int start_column |]
;;

let strict_contains_range t range =
  Jv.call t "strictContainsRange" [| range |] |> Jv.to_bool
;;

let to_string t = Jv.call t "toString" [||] |> Jv.to_string
let range () = Jv.get (monaco ()) "Range"

let are_intersecting r1 r2 =
  Jv.apply (Jv.get (range ()) "areIntersecting") [| r1; r2 |] |> Jv.to_bool
;;

let are_intersecting_or_touching r1 r2 =
  Jv.apply (Jv.get (range ()) "areIntersectingOrTouching") [| r1; r2 |] |> Jv.to_bool
;;

(* let collapse_to_start r = Jv.apply (Jv.get (range ()) "collapseToStart") [| r |] *)

let compare_ranges_using_ends r1 r2 =
  Jv.apply (Jv.get (range ()) "compareRangesUsingEnds") [| r1; r2 |] |> Jv.to_int
;;

let compare_ranges_using_starts r1 r2 =
  Jv.apply (Jv.get (range ()) "compareRangesUsingStarts") [| r1; r2 |] |> Jv.to_int
;;

(*
let contains_position r pos =
  Jv.apply (Jv.get (range ()) "containsPosition") [| r; Position.to_jv pos |]
  |> Jv.to_bool
;;

let contains_range r1 r2 =
  Jv.apply (Jv.get (range ()) "containsRange") [| r1; r2 |] |> Jv.to_bool
;;

let equals_range r1 r2 =
  Jv.apply (Jv.get (range ()) "equalsRange") [| r1; r2 |] |> Jv.to_bool
;;
*)

let from_positions p1 p2 =
  Jv.apply (Jv.get (range ()) "fromPositions") [| Position.to_jv p1; Position.to_jv p2 |]
;;

(*
let get_end_position r =
  Jv.apply (Jv.get (range ()) "getEndPosition") [| r |] |> Position.of_jv
;;

let get_start_position r =
  Jv.apply (Jv.get (range ()) "getStartPosition") [| r |] |> Position.of_jv
;;

let intersect_ranges r1 r2 = Jv.apply (Jv.get (range ()) "intersectRanges") [| r1; r2 |]
*)
(* TODO let is_empty t = Jv.apply (Jv.get (range ()) "isEmpty") [| t |] |> Jv.to_bool *)
