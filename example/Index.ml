open Brr

let initial_content = {|function x() {
  console.log("Hello world!");
}|}

let () =
  match Document.find_el_by_id G.document (Jstr.v "container") with
  | None -> Console.(log [ str "couldn't find container" ])
  | Some container ->
    Require.(
      config ~paths:[ "vs", "npm-package-0.29.1/min/vs" ] ();
      require [ "vs/editor/editor.main" ] (fun () ->
          ignore
          @@ Monaco.Editor.create ~value:initial_content ~language:"javascript" container))
;;
