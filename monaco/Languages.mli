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

module Position : sig
  type t =
    { line_number : int
    ; column : int
    }

  val to_jv : t -> Jv.t
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

module Completion_item : sig
  type t =
    { label : (string, Completion_item_label.t) Either.t
    ; kind : Completion_item_kind.t (* TODO tags, documentation *)
    ; detail : string option
    }
end

module Completion_item_provider : sig
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

  val to_jv : t -> Jv.t
end

val register : language_id:string -> unit
val set_monarch_tokens_provider : language_id:string -> Monarch.t -> unit

val register_completion_item_provider
  :  language_id:string
  -> Completion_item_provider.t
  -> unit
