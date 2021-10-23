let init cb =
  Require.config ~paths:[ "vs", "npm-package-0.29.1/min/vs" ] ();
  Require.require [ "vs/editor/editor.main" ] cb
;;

module Languages = Languages
module Editor = Editor
module Minimap_options = Minimap_options
