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
          let provide_completion_items _model _position _ctx _tok =
            Languages.Completion_item.
              [ { label = Left "simpleText"
                ; kind = Text
                ; detail = None
                ; insert_text = "simpleText"
                ; insert_text_rules = None
                ; range = None
                ; documentation = None
                }
              ; { label = Left "testing"
                ; kind = Keyword
                ; detail = None
                ; insert_text = "testing(${1:condition})"
                ; insert_text_rules = Some InsertAsSnippet
                ; range = None
                ; documentation = None
                }
              ; { label = Left "ifelse"
                ; kind = Snippet
                ; detail = None
                ; insert_text = {|if (${1:condition}) {
  $0
} else {

}|}
                ; insert_text_rules = Some InsertAsSnippet
                ; range = None
                ; documentation = Some "If-Else Statement"
                }
              ]
          in
          let item_provider =
            Languages.Completion_item_provider.
              { trigger_characters = Some "xyz"; provide_completion_items }
          in
          Languages.register_completion_item_provider ~language_id item_provider;
          ignore @@ Editor.create ~value:initial_content ~language:language_id container))
;;
