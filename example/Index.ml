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
              [ { label = String_label "simpleText"
                ; kind = Text
                ; detail = None
                ; insert_text = "simpleText"
                ; insert_text_rules = None
                ; range = None
                ; documentation = None
                }
              ; { label = String_label "testing"
                ; kind = Keyword
                ; detail = None
                ; insert_text = "testing(${1:condition})"
                ; insert_text_rules = Some Insert_as_snippet
                ; range = None
                ; documentation = None
                }
              ; { label = String_label "ifelse"
                ; kind = Snippet
                ; detail = None
                ; insert_text = {|if (${1:condition}) {
  $0
} else {

}|}
                ; insert_text_rules = Some Insert_as_snippet
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
          let editor =
            Editor.create ~value:initial_content ~language:language_id container
          in
          ignore
          @@ Editor.add_command
               editor
               ~keybinding:2 (* tab *)
               (* ~context:"myCondition1 && myCondition2" *)
               (fun _ -> Console.(log [ str "my command is executing!" ]));
          let ctrl = KeyMod.ctrl_cmd () in
          ignore
          @@ Editor.add_action
               ~id:"my-unique-id"
               ~label:"My Label!!!"
               ~keybindings:
                 [ (ctrl lor KeyCode.(to_int F10))
                 ; KeyMod.chord
                     (ctrl lor KeyCode.(to_int KEY_K))
                     (ctrl lor KeyCode.(to_int KEY_M))
                 ]
               ~context_menu_group_id:"navigation"
               ~context_menu_order:1.5
               ~run:(Jv.repr (fun ed -> Console.(log [ str "running in editor", ed ])))
               editor))
;;
