let init cb =
  Require.config ~paths:[ "vs", "npm-package-0.29.1/min/vs" ] ();
  Require.require [ "vs/editor/editor.main" ] cb
;;

module Languages = Languages
module Editor = Editor
module Minimap_options = Minimap_options
module KeyMod = KeyMod
module KeyCode = KeyCode
module Position = Position
module Range = Range
module Token = Token
module Uri = Uri
