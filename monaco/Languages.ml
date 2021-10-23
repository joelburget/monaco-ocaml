(* open Brr *)
open Helpers

let languages () = Jv.get (monaco ()) "languages"

(*
module Monarch_language = struct
  type t = Jv.t
end
*)

module Completion_item_kind = struct
  type t =
    | Method
    | Function
    | Constructor
    | Field
    | Variable
    | Class
    | Struct
    | Interface
    | Module
    | Property
    | Event
    | Operator
    | Unit
    | Value
    | Constant
    | Enum
    | EnumMember
    | Keyword
    | Text
    | Color
    | File
    | Reference
    | Customcolor
    | Folder
    | TypeParameter
    | User
    | Issue
    | Snippet
end

module Text_model = struct
  type t = { (* TODO: Uri *)
             id : string }
end

module Position = struct
  type t =
    { line_number : int
    ; column : int
    }

  let to_jv { line_number; column } =
    Jv.obj [| "lineNumber", Jv.of_int line_number; "column", Jv.of_int column |]
  ;;
end

module Completion_trigger_kind = struct
  type t =
    | Invoke
    | Trigger_character
    | Trigger_for_incomplete_completions

  let to_jv x =
    let i =
      match x with
      | Invoke -> 0
      | Trigger_character -> 1
      | Trigger_for_incomplete_completions -> 2
    in
    Jv.of_int i
  ;;
end

module Completion_context = struct
  type t =
    { trigger_kind : Completion_trigger_kind.t
    ; trigger_character : string option
    }

  let to_jv { trigger_kind; trigger_character } =
    let obj = Jv.obj [| "triggerKind", Completion_trigger_kind.to_jv trigger_kind |] in
    set_opt_str obj "triggerCharacter" trigger_character;
    obj
  ;;
end

module Cancellation_token = struct
  type t
end

module Completion_item_label = struct
  type t =
    { label : string
    ; detail : string option
    ; description : string option
    }

  let to_jv { label; detail; description } =
    let obj = Jv.obj [| "label", Jv.of_string label |] in
    set_opt_str obj "detail" detail;
    set_opt_str obj "description" description;
    obj
  ;;
end

module Completion_item = struct
  type t =
    { label : (string, Completion_item_label.t) Either.t
    ; kind : Completion_item_kind.t (* TODO tags, documentation *)
    ; detail : string option
    }
end

module Completion_item_provider = struct
  type t =
    { trigger_characters : string option
    ; provide_completion_items :
        Text_model.t
        -> Position.t
        -> Completion_context.t
        -> Cancellation_token.t
        -> Completion_item.t
          (* ; resolve_completion_item *)
    }

  let to_jv { trigger_characters; provide_completion_items = _ } =
    let obj = Jv.obj [||] in
    set_opt_str obj "triggerCharacters" trigger_characters;
    obj
  ;;
end

let register ~language_id =
  ignore
  @@ Jv.call (languages ()) "register" [| Jv.obj [| "id", Jv.of_string language_id |] |]
;;

let set_monarch_tokens_provider ~language_id language =
  ignore
  @@ Jv.call
       (languages ())
       "setMonarchTokensProvider"
       [| Jv.of_string language_id; Monarch.to_jv language |]
;;

let register_completion_item_provider ~language_id item_provider =
  ignore
  @@ Jv.call
       (languages ())
       "registerCompletionItemProvider"
       [| Jv.of_string language_id; Completion_item_provider.to_jv item_provider |]
;;
