module Completion_item_kind : sig
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

module Text_model : sig
  type t = { (* TODO: Uri *)
             id : string }
end

module Completion_trigger_kind : sig
  type t =
    | Invoke
    | Trigger_character
    | Trigger_for_incomplete_completions

  val to_jv : t -> Jv.t
end

module Completion_context : sig
  type t =
    { trigger_kind : Completion_trigger_kind.t
    ; trigger_character : string option
    }

  val to_jv : t -> Jv.t
end

module Cancellation_token : sig
  type t
end

module Completion_item_label : sig
  type t =
    { label : string
    ; detail : string option
    ; description : string option
    }

  val to_jv : t -> Jv.t
end

(*
module Range : sig
  type t =
    { start_line_number : int
    ; start_column : int
    ; end_line_number : int
    ; end_column : int
    }

  val to_jv : t -> Jv.t
end
   *)

module Completion_item_insert_text_rule : sig
  type t =
    | Keep_whitespace
    | Insert_as_snippet

  val to_jv : t -> Jv.t
end

module Completion_item : sig
  type label =
    | String_label of string
    | Completion_item_label of Completion_item_label.t

  type t =
    { label : label
    ; kind : Completion_item_kind.t
    ; detail : string option
    ; insert_text : string
    ; insert_text_rules : Completion_item_insert_text_rule.t option
    ; range : Range.t option
    ; documentation : string option
    }

  val to_jv : t -> Jv.t
end

module Completion_list : sig
  type t = Completion_item.t list

  val to_jv : t -> Jv.t
end

module Completion_item_provider : sig
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

  val to_jv : t -> Jv.t
end

val register : language_id:string -> unit
val set_monarch_tokens_provider : language_id:string -> Monarch.t -> unit

val register_completion_item_provider
  :  language_id:string
  -> Completion_item_provider.t
  -> unit
