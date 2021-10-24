open Brr
open Helpers

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

module Disposable = struct
  type t = Jv.t

  let dispose t = ignore @@ Jv.call t "dispose" [||]
end

type t = Jv.t
type editor_construction_options

let editor () = Jv.get (monaco ()) "editor"

let create ?value ?language ?theme ?contextmenu el =
  let opts = Jv.obj [||] in
  set_opt_str opts "value" value;
  set_opt_str opts "language" language;
  set_opt_str opts "theme" theme;
  set_opt_bool opts "contextmenu" contextmenu;
  Jv.call (editor ()) "create" [| El.to_jv el; opts |]
;;

(*
    let create_diff_editor ?theme ?contextmenu el =
      let opts = Jv.obj [||] in
      set_opt_str opts "theme" theme;
      set_opt_bool opts "contextmenu" contextmenu;
      Jv.call editor "createDiffEditor" [| El.to_jv el; opts |]
    ;;
       *)

let add_command editor ~keybinding ?context command_handler =
  let args =
    [| Jv.of_int keybinding
     ; Jv.repr command_handler (* TODO: ensure handles / returns Jv.t *)
    |]
  in
  let args =
    match context with
    | None -> args
    | Some context -> Array.append args [| Jv.of_string context |]
  in
  Jv.call editor "addCommand" args |> Jv.to_option Jv.to_string
;;

let add_action
    ~id
    ~label
    ~run
    ?precondition
    ?keybindings
    ?keybinding_context
    ?context_menu_group_id
    ?context_menu_order
    editor
  =
  let descriptor =
    Jv.obj [| "id", Jv.of_string id; "label", Jv.of_string label; "run", run |]
  in
  set_opt_str descriptor "precondition" precondition;
  set_opt_list ~f:Jv.of_int descriptor "keybindings" keybindings;
  set_opt_str descriptor "keybindingContext" keybinding_context;
  set_opt_str descriptor "contextMenuGroupId" context_menu_group_id;
  set_opt_float descriptor "contextMenuOrder" context_menu_order;
  Jv.call editor "addAction" [| descriptor |]
;;

let focus editor = ignore @@ Jv.call editor "focus" [||]

let layout ?dimension editor =
  let args =
    match dimension with Some dimension -> [| Dimension.to_jv dimension |] | None -> [||]
  in
  ignore @@ Jv.call editor "layout" args
;;
