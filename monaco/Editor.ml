open Brr
open Helpers

let monaco () = Jv.get Jv.global "monaco"

module Render_line_numbers_type = struct
  type t =
    | Custom
    | Interval
    | Relative
    | On
    | Off

  let to_int = function Custom -> 4 | Interval -> 3 | Relative -> 2 | On -> 1 | Off -> 0
end

module Render_minimap = struct
  type t =
    | Blocks
    | Text
    | None

  let to_int = function Blocks -> 2 | Text -> 1 | None -> 0
end

module Minimap_position = struct
  type t =
    | Gutter
    | Inline

  let to_int = function Gutter -> 2 | Inline -> 1
end

type t = Jv.t
type editor_construction_options

let editor () = Jv.get (monaco ()) "editor"

let create ?value ?language ?theme ?contextmenu el =
  let editor = editor () in
  let opts = Jv.obj [||] in
  set_opt_str opts "value" value;
  set_opt_str opts "language" language;
  set_opt_str opts "theme" theme;
  set_opt_bool opts "contextmenu" contextmenu;
  Jv.call editor "create" [| El.to_jv el; opts |]
;;

(*
    let create_diff_editor ?theme ?contextmenu el =
      let opts = Jv.obj [||] in
      set_opt_str opts "theme" theme;
      set_opt_bool opts "contextmenu" contextmenu;
      Jv.call editor "createDiffEditor" [| El.to_jv el; opts |]
    ;;
       *)
