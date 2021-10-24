open Helpers

type t =
  { end_column : int
  ; end_line_number : int
  ; position_column : int
  ; position_line_number : int
  ; selection_start_column : int
  ; selection_start_line_number : int
  ; start_column : int
  ; start_line_number : int
  }

let to_jv
    { selection_start_line_number
    ; selection_start_column
    ; position_line_number
    ; position_column
    ; _
    }
  =
  Jv.new'
    (Jv.get (monaco ()) "Selection")
    [| Jv.of_int selection_start_line_number
     ; Jv.of_int selection_start_column
     ; Jv.of_int position_line_number
     ; Jv.of_int position_column
    |]
;;
