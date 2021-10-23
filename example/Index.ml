open Brr

let initial_content =
  {|// Type source code in your language here...
class MyClass {
  @attribute
  void main() {
    Console.writeln( "Hello Monarch world\n");
  }
}|}
;;

let () =
  match Document.find_el_by_id G.document (Jstr.v "container") with
  | None -> Console.(log [ str "couldn't find container" ])
  | Some container ->
    Monaco.(
      init (fun () ->
          let language_id = "mylang" in
          Languages.register ~language_id;
          Languages.set_monarch_tokens_provider ~language_id Monarch.example2;
          ignore @@ Editor.create ~value:initial_content ~language:language_id container))
;;
