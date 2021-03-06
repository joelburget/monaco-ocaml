module Helpers = Helpers
open Helpers

module Bracket = struct
  type t =
    { close : string
    ; open' : string
    ; token : string
    }

  let to_jv { close; open'; token } =
    Jv.obj
      [| "close", Jv.of_string close
       ; "open", Jv.of_string open'
       ; "token", Jv.of_string token
      |]
  ;;
end

module Regex = struct
  type t = string

  let to_jv s =
    let regexp = Jv.get Jv.global "RegExp" in
    Jv.apply regexp [| Jv.of_string s |]
  ;;
end

module Language_action = struct
  type t =
    | Short of string
    | Expanded of
        { group : t list option
        ; cases : (string * t) list option
        ; token : string option
        ; next : string option
        ; switch_to : string option
        ; go_back : int option
        ; bracket : string option
        ; next_embedded : string option
        ; log : string option
        }

  let rec to_jv = function
    | Short name -> Jv.of_string name
    | Expanded
        { group; cases; token; next; switch_to; go_back; bracket; next_embedded; log } ->
      let obj = Jv.obj [||] in
      set_opt_list ~f:to_jv obj "group" group;
      set_opt_obj ~f:(fun (k, v) -> k, to_jv v) obj "cases" cases;
      set_opt_str obj "token" token;
      set_opt_str obj "next" next;
      set_opt_str obj "switchTo" switch_to;
      set_opt_int obj "goBack" go_back;
      set_opt_str obj "bracket" bracket;
      set_opt_str obj "nextEmbedded" next_embedded;
      set_opt_str obj "log" log;
      obj
  ;;
end

let language_action
    ?group
    ?cases
    ?token
    ?next
    ?switch_to
    ?go_back
    ?bracket
    ?next_embedded
    ?log
    ()
  =
  Language_action.Expanded
    { group; cases; token; next; switch_to; go_back; bracket; next_embedded; log }
;;

module Language_rule = struct
  type regex =
    | String of string
    | Regex of Regex.t

  type t =
    { regex : regex option
    ; action : Language_action.t option
    ; include' : string option
    }

  let mk ?regex ?action ?include' () = { regex; action; include' }

  let to_jv { regex; action; include' } =
    let obj = Jv.obj [||] in
    set_opt
      ~f:(function String str -> Jv.of_string str | Regex regex -> Regex.to_jv regex)
      obj
      "regex"
      regex;
    set_opt ~f:Language_action.to_jv obj "action" action;
    set_opt_str obj "include" include';
    obj
  ;;
end

let language_rule ?regex ?string ?action ?include' () =
  let regex =
    match regex, string with
    | Some regex, None -> Some (Language_rule.Regex regex)
    | None, Some string -> Some (String string)
    | None, None -> None
    | Some _, Some _ -> failwith "language_rule: regex and string are mutually exclusive"
  in
  Language_rule.mk ?regex ?action ?include' ()
;;

(* TODO: indexable other keys, includeLF *)
type t =
  { definitions : (string * Jv.t) list
  ; brackets : Bracket.t list option
  ; default_token : string option
  ; ignore_case : bool option
  ; start : string option
  ; tokenizer : (string * Language_rule.t list) list
  }

let mk ?(definitions = []) ?brackets ?default_token ?ignore_case ?start tokenizer =
  { definitions; brackets; default_token; ignore_case; start; tokenizer }
;;

let to_jv { definitions; brackets; default_token; ignore_case; start; tokenizer } =
  let tokenizer =
    tokenizer
    |> Array.of_list
    |> Array.map (fun (k, v) -> k, Jv.of_list Language_rule.to_jv v)
    |> Jv.obj
  in
  let obj_fields = ("tokenizer", tokenizer) :: definitions in
  let obj = Jv.obj (Array.of_list obj_fields) in
  set_opt_list ~f:Bracket.to_jv obj "brackets" brackets;
  set_opt_str obj "defaultToken" default_token;
  set_opt_bool obj "ignoreCase" ignore_case;
  set_opt_str obj "start" start;
  obj
;;

let example1 =
  mk
    [ ( "root"
      , [ language_rule ~regex:{|\[error.*|} ~action:(Short "custom-error") ()
        ; language_rule ~regex:{|\[notice.*|} ~action:(Short "custom-notice") ()
        ; language_rule ~regex:{|\[info.*|} ~action:(Short "custom-info") ()
        ; language_rule ~regex:{|\[[a-zA-Z 0-9:]+\]|} ~action:(Short "custom-date") ()
        ] )
    ]
;;

let example2 =
  mk
    ~definitions:
      [ ( "keywords"
        , Jv.of_list
            Jv.of_string
            [ "abstract"
            ; "continue"
            ; "for"
            ; "new"
            ; "switch"
            ; "assert"
            ; "goto"
            ; "do"
            ; "if"
            ; "private"
            ; "this"
            ; "break"
            ; "protected"
            ; "throw"
            ; "else"
            ; "public"
            ; "enum"
            ; "return"
            ; "catch"
            ; "try"
            ; "interface"
            ; "static"
            ; "class"
            ; "finally"
            ; "const"
            ; "super"
            ; "while"
            ; "true"
            ; "false"
            ] )
      ; ( "typeKeywords"
        , Jv.of_list
            Jv.of_string
            [ "boolean"
            ; "double"
            ; "byte"
            ; "int"
            ; "short"
            ; "char"
            ; "void"
            ; "long"
            ; "float"
            ] )
      ; ( "operators"
        , Jv.of_list
            Jv.of_string
            [ "="
            ; ">"
            ; "<"
            ; "!"
            ; "~"
            ; "?"
            ; ":"
            ; "=="
            ; "<="
            ; ">="
            ; "!="
            ; "&&"
            ; "||"
            ; "++"
            ; "--"
            ; "+"
            ; "-"
            ; "*"
            ; "/"
            ; "&"
            ; "|"
            ; "^"
            ; "%"
            ; "<<"
            ; ">>"
            ; ">>>"
            ; "+="
            ; "-="
            ; "*="
            ; "/="
            ; "&="
            ; "|="
            ; "^="
            ; "%="
            ; "<<="
            ; ">>="
            ; ">>>="
            ] )
      ; "symbols", Regex.to_jv {|[=><!~?:&|+\-*\/\^%]+|}
      ; ( "escapes"
        , Regex.to_jv
            {|\\(?:[abfnrtv\\"']|x[0-9A-Fa-f]{1,4}|u[0-9A-Fa-f]{4}|U[0-9A-Fa-f]{8})|} )
      ]
    [ ( "root"
      , [ (* identifiers and keywords *)
          language_rule
            ~regex:{|[a-z_$][\w$]*|}
            ~action:
              (language_action
                 ~cases:
                   [ "@typeKeywords", Short "keyword"
                   ; "@keywords", Short "keyword"
                   ; "@default", Short "identifier"
                   ]
                 ())
            ()
        ; language_rule ~regex:{|[A-Z][\w\$]*|} ~action:(Short "type.identifier") ()
        ; (* whitespace *)
          language_rule ~include':"@whitespace" ()
        ; (* delimiters and operators *)
          language_rule ~regex:{|[{}()\[\]]|} ~action:(Short "@brackets") ()
        ; language_rule ~regex:{|[<>](?!@symbols)|} ~action:(Short "@brackets") ()
        ; language_rule
            ~regex:{|@symbols|}
            ~action:
              (language_action
                 ~cases:[ "@operators", Short "operator"; "@default", Short "" ]
                 ())
            ()
        ; (* annotations *)
          language_rule
            ~regex:{|@\s*[a-zA-Z_\$][\w\$]*|}
            ~action:(language_action ~token:"annotation" ~log:"annotation token: $0" ())
            ()
        ; (* numbers *)
          language_rule
            ~regex:{|\d*\.\d+([eE][\-+]?\d+)?|}
            ~action:(Short "number.float")
            ()
        ; language_rule ~regex:{|0[xX][0-9a-fA-F]+|} ~action:(Short "number.hex") ()
        ; language_rule ~regex:{|\d+|} ~action:(Short "number") ()
        ; (* delimiter: after number because of .\d floats *)
          language_rule ~regex:{|[;,.]|} ~action:(Short "delimiter") ()
        ; (* strings *)
          language_rule ~regex:{|"([^"\\]|\\.)*$|} ~action:(Short "string.invalid") ()
        ; language_rule
            ~regex:{|"|}
            ~action:
              (language_action ~token:"string.quote" ~bracket:"@open" ~next:"@string" ())
            ()
        ; (* characters *)
          language_rule ~regex:{|'[^\\']'|} ~action:(Short "string") ()
        ; language_rule ~regex:{|(')(@escapes)(')|} ~action:(Short "string") ()
        ; language_rule ~regex:{|'|} ~action:(Short "string.invalid") ()
        ] )
    ; ( "comment"
      , [ language_rule ~regex:{|[^\/*]+|} ~action:(Short "comment") ()
        ; language_rule
            ~regex:{|\/\*|}
            ~action:(language_action ~token:"comment" ~next:"@push" ())
            ()
        ; language_rule
            ~regex:{|\*/|}
            ~action:(language_action ~token:"comment" ~next:"@pop" ())
            ()
        ; language_rule ~regex:{|[\/*]|} ~action:(Short "comment") ()
        ] )
    ; ( "string"
      , [ language_rule ~regex:{|[^\\"]+|} ~action:(Short "string") ()
        ; language_rule ~regex:{|@escapes|} ~action:(Short "string.escape") ()
        ; language_rule ~regex:{|\\.|} ~action:(Short "string.escape.invalid") ()
        ; language_rule
            ~regex:{|"|}
            ~action:
              (language_action ~token:"string.quote" ~bracket:"@close" ~next:"@pop" ())
            ()
        ] )
    ; ( "whitespace"
      , [ language_rule ~regex:{|[ \t\r\n]+|} ~action:(Short "white") ()
        ; language_rule
            ~regex:{|\/\*|}
            ~action:(language_action ~token:"comment" ~next:"@comment" ())
            ()
        ; language_rule ~regex:{|//.*$|} ~action:(Short "comment") ()
        ] )
    ]
;;
