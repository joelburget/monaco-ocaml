open Helpers

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
