type t
type editor_construction_options

(*
  module Context_key : sig
    type t
  end

  val create_context_key : key:string ->
     *)

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

module Disposable : sig
  type t

  val dispose : t -> unit
end

val create
  :  ?value:string
  -> ?language:string
  -> ?theme:string
  -> ?contextmenu:bool
  -> Brr.El.t
  -> t

val add_command
  :  t
  -> keybinding:int
  -> ?context:string
  -> (unit -> unit)
  -> string option

(* TODO: val createContextKey : key:string -> defaultValue:'a -> 'a ContextKey.t *)

val add_action
  :  id:string
  -> label:string
  -> run:Jv.t
  -> ?precondition:string
  -> ?keybindings:int list
  -> ?keybinding_context:string
  -> ?context_menu_group_id:string
  -> ?context_menu_order:float
  -> t
  -> Disposable.t

val focus : t -> unit
val layout : ?dimension:Dimension.t -> t -> unit

(* TODO:
  * updateOptions(newOptions: IEditorOptions & IGlobalEditorOptions): void;
  * addAction(descriptor: IActionDescriptor): IDisposable;
*)
