open Helpers

let key_mod () = Jv.get (monaco ()) "KeyMod"
let ctrl_cmd () = Jv.get (key_mod ()) "CtrlCmd" |> Jv.to_int
let shift () = Jv.get (key_mod ()) "Shift" |> Jv.to_int
let alt () = Jv.get (key_mod ()) "Alt" |> Jv.to_int
let win_ctrl () = Jv.get (key_mod ()) "WinCtrl" |> Jv.to_int

let chord first_part second_part =
  Jv.call (key_mod ()) "chord" [| Jv.of_int first_part; Jv.of_int second_part |]
  |> Jv.to_int
;;
