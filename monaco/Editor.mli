type t
type editor_construction_options

val create
  :  ?value:string
  -> ?language:string
  -> ?theme:string
  -> ?contextmenu:bool
  -> Brr.El.t
  -> t

(*
  module Context_key : sig
    type t
  end

  val create_context_key : key:string ->
     *)

(* val add_command : keybinding:int -> ?context:string -> (unit -> unit) -> unit *)

module Render_line_numbers_type : sig
  type t =
    | Custom
    | Interval
    | Relative
    | On
    | Off

  val to_int : t -> int
end

module Render_minimap : sig
  type t =
    | Blocks
    | Text
    | None

  val to_int : t -> int
end

module Minimap_position : sig
  type t =
    | Gutter
    | Inline

  val to_int : t -> int
end
