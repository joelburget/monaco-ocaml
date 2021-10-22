open Brr

let monaco () = Jv.get Jv.global "monaco"

module type Variant_s = sig
  type t

  val to_string : t -> string
  val name : string
end

module Extend (Variant : Variant_s) = struct
  let set_opt obj opt_val =
    match opt_val with
    | None -> ()
    | Some value -> Jv.Jstr.set obj Variant.name (Jstr.v (Variant.to_string value))
  ;;
end

let set_opt_str obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Jstr.set obj name (Jstr.v value)
;;

let set_opt_bool obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Bool.set obj name value
;;

let set_opt_int obj name opt_val =
  match opt_val with None -> () | Some value -> Jv.Int.set obj name value
;;

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
end = struct
  module Show_slider = struct
    module Kernel = struct
      type t =
        | Always
        | Mouseover

      let to_string = function Always -> "always" | Mouseover -> "mouseover"
      let name = "showSlider"
    end

    include Kernel
    include Extend (Kernel)
  end

  module Side = struct
    module Kernel = struct
      type t =
        | Right
        | Left

      let to_string = function Right -> "right" | Left -> "left"
      let name = "side"
    end

    include Kernel
    include Extend (Kernel)
  end

  module Size = struct
    module Kernel = struct
      type t =
        | Proportional
        | Fill
        | Fit

      let to_string = function
        | Proportional -> "proportional"
        | Fill -> "fill"
        | Fit -> "fit"
      ;;

      let name = "size"
    end

    include Kernel
    include Extend (Kernel)
  end

  type t = Jv.t

  let create ?enabled ?max_column ?render_characters ?scale ?show_slider ?side ?size () =
    let opts = Jv.obj [||] in
    set_opt_bool opts "enabled" enabled;
    set_opt_int opts "maxColumn" max_column;
    set_opt_bool opts "renderCharacters" render_characters;
    set_opt_int opts "scale" scale;
    Show_slider.set_opt opts show_slider;
    Side.set_opt opts side;
    Size.set_opt opts size;
    opts
  ;;
end

module Editor = struct
  module Render_line_numbers_type = struct
    type t =
      | Custom
      | Interval
      | Relative
      | On
      | Off

    let to_int = function
      | Custom -> 4
      | Interval -> 3
      | Relative -> 2
      | On -> 1
      | Off -> 0
    ;;
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
end
