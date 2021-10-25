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

  let to_int = function
    | Method -> 0
    | Function -> 1
    | Constructor -> 2
    | Field -> 3
    | Variable -> 4
    | Class -> 5
    | Struct -> 6
    | Interface -> 7
    | Module -> 8
    | Property -> 9
    | Event -> 10
    | Operator -> 11
    | Unit -> 12
    | Value -> 13
    | Constant -> 14
    | Enum -> 15
    | EnumMember -> 16
    | Keyword -> 17
    | Text -> 18
    | Color -> 19
    | File -> 20
    | Reference -> 21
    | Customcolor -> 22
    | Folder -> 23
    | TypeParameter -> 24
    | User -> 25
    | Issue -> 26
    | Snippet -> 27
  ;;

  let to_jv x = x |> to_int |> Jv.of_int
end

module Text_model = struct
  type t = { (* TODO: Uri *)
             id : string }
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

(*
module Range = struct
  type t =
    { start_line_number : int
    ; start_column : int
    ; end_line_number : int
    ; end_column : int
    }

  let to_jv { start_line_number; start_column; end_line_number; end_column } =
    Jv.obj
      [| "startLineNumber", Jv.of_int start_line_number
       ; "startColumn", Jv.of_int start_column
       ; "endLineNumber", Jv.of_int end_line_number
       ; "endColumn", Jv.of_int end_column
      |]
  ;;
end
   *)

module Completion_item_insert_text_rule = struct
  type t =
    | Keep_whitespace
    | Insert_as_snippet

  let to_int = function Keep_whitespace -> 1 | Insert_as_snippet -> 4
  let to_jv x = x |> to_int |> Jv.of_int
end

module Completion_item = struct
  type label =
    | String_label of string
    | Completion_item_label of Completion_item_label.t

  type t =
    { (* TODO tags, etc *)
      label : label
    ; kind : Completion_item_kind.t
    ; detail : string option
    ; insert_text : string
    ; insert_text_rules : Completion_item_insert_text_rule.t option
    ; range : Range.t option
    ; documentation : string option
    }

  (*
  let mk ?detail ~label ~kind ~insert_text ~range () =
    { label; kind; detail; insert_text; range }
  ;;
     *)

  let to_jv { label; kind; detail; insert_text; insert_text_rules; range; documentation } =
    let label =
      match label with
      | String_label str -> Jv.of_string str
      | Completion_item_label item_label -> Completion_item_label.to_jv item_label
    in
    let obj =
      Jv.obj
        [| "label", label
         ; "kind", Completion_item_kind.to_jv kind
         ; "insertText", Jv.of_string insert_text
        |]
    in
    set_opt ~f:Range.to_jv obj "range" range;
    set_opt
      ~f:Completion_item_insert_text_rule.to_jv
      obj
      "insertTextRules"
      insert_text_rules;
    set_opt_str obj "detail" detail;
    set_opt_str obj "documentation" documentation;
    obj
  ;;
end

module Completion_list = struct
  type t = Completion_item.t list

  let to_jv items =
    let obj = Jv.obj [||] in
    Jv.set obj "suggestions" (Jv.of_list Completion_item.to_jv items);
    obj
  ;;
end

module Completion_item_provider = struct
  type t =
    { trigger_characters : string option
    ; provide_completion_items :
        Text_model.t
        -> Position.t
        -> Completion_context.t
        -> Cancellation_token.t
        -> Completion_list.t
          (* ; resolve_completion_item *)
    }

  let to_jv { trigger_characters; provide_completion_items } =
    let provide_completion_items model pos ctx tok =
      provide_completion_items model pos ctx tok |> Completion_list.to_jv
    in
    let obj = Jv.obj [| "provideCompletionItems", Jv.repr provide_completion_items |] in
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
