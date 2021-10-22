module Show_slider : sig
  type t =
    | Always
    | Mouseover
end

module Side : sig
  type t =
    | Right
    | Left
end

module Size : sig
  type t =
    | Proportional
    | Fill
    | Fit
end

type t

val create
  :  ?enabled:bool
  -> ?max_column:int
  -> ?render_characters:bool
  -> ?scale:int
  -> ?show_slider:Show_slider.t
  -> ?side:Side.t
  -> ?size:Size.t
  -> unit
  -> t
