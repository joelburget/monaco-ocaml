module Minimap_options : sig
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
end

module Editor : sig
  type t
  type editor_construction_options

  val create
    :  ?value:string
    -> ?language:string
    -> ?theme:string
    -> ?contextmenu:bool
    -> Brr.El.t
    -> t

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
end
