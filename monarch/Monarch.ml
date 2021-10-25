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

  let mk_expanded
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
    Expanded
      { group; cases; token; next; switch_to; go_back; bracket; next_embedded; log }
  ;;

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
      , [ Language_rule.mk ~regex:(Regex {|\[error.*|}) ~action:(Short "custom-error") ()
        ; Language_rule.mk
            ~regex:(Regex {|\[notice.*|})
            ~action:(Short "custom-notice")
            ()
        ; Language_rule.mk ~regex:(Regex {|\[info.*|}) ~action:(Short "custom-info") ()
        ; Language_rule.mk
            ~regex:(Regex {|\[[a-zA-Z 0-9:]+\]|})
            ~action:(Short "custom-date")
            ()
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
          Language_rule.mk
            ~regex:(Regex {|[a-z_$][\w$]*|})
            ~action:
              (Language_action.mk_expanded
                 ~cases:
                   [ "@typeKeywords", Short "keyword"
                   ; "@keywords", Short "keyword"
                   ; "@default", Short "identifier"
                   ]
                 ())
            ()
        ; Language_rule.mk
            ~regex:(Regex {|[A-Z][\w\$]*|})
            ~action:(Short "type.identifier")
            ()
        ; (* whitespace *)
          Language_rule.mk ~include':"@whitespace" ()
        ; (* delimiters and operators *)
          Language_rule.mk ~regex:(Regex {|[{}()\[\]]|}) ~action:(Short "@brackets") ()
        ; Language_rule.mk
            ~regex:(Regex {|[<>](?!@symbols)|})
            ~action:(Short "@brackets")
            ()
        ; Language_rule.mk
            ~regex:(Regex {|@symbols|})
            ~action:
              (Language_action.mk_expanded
                 ~cases:[ "@operators", Short "operator"; "@default", Short "" ]
                 ())
            ()
        ; (* annotations *)
          Language_rule.mk
            ~regex:(Regex {|@\s*[a-zA-Z_\$][\w\$]*|})
            ~action:
              (Language_action.mk_expanded
                 ~token:"annotation"
                 ~log:"annotation token: $0"
                 ())
            ()
        ; (* numbers *)
          Language_rule.mk
            ~regex:(Regex {|\d*\.\d+([eE][\-+]?\d+)?|})
            ~action:(Short "number.float")
            ()
        ; Language_rule.mk
            ~regex:(Regex {|0[xX][0-9a-fA-F]+|})
            ~action:(Short "number.hex")
            ()
        ; Language_rule.mk ~regex:(Regex {|\d+|}) ~action:(Short "number") ()
        ; (* delimiter: after number because of .\d floats *)
          Language_rule.mk ~regex:(Regex {|[;,.]|}) ~action:(Short "delimiter") ()
        ; (* strings *)
          Language_rule.mk
            ~regex:(Regex {|"([^"\\]|\\.)*$|})
            ~action:(Short "string.invalid")
            ()
        ; Language_rule.mk
            ~regex:(Regex {|"|})
            ~action:
              (Language_action.mk_expanded
                 ~token:"string.quote"
                 ~bracket:"@open"
                 ~next:"@string"
                 ())
            ()
        ; (* characters *)
          Language_rule.mk ~regex:(Regex {|'[^\\']'|}) ~action:(Short "string") ()
        ; Language_rule.mk ~regex:(Regex {|(')(@escapes)(')|}) ~action:(Short "string") ()
        ; Language_rule.mk ~regex:(Regex {|'|}) ~action:(Short "string.invalid") ()
        ] )
    ; ( "comment"
      , [ Language_rule.mk ~regex:(Regex {|[^\/*]+|}) ~action:(Short "comment") ()
        ; Language_rule.mk
            ~regex:(Regex {|\/\*|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@push" ())
            ()
        ; Language_rule.mk
            ~regex:(Regex {|\*/|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@pop" ())
            ()
        ; Language_rule.mk ~regex:(Regex {|[\/*]|}) ~action:(Short "comment") ()
        ] )
    ; ( "string"
      , [ Language_rule.mk ~regex:(Regex {|[^\\"]+|}) ~action:(Short "string") ()
        ; Language_rule.mk ~regex:(Regex {|@escapes|}) ~action:(Short "string.escape") ()
        ; Language_rule.mk
            ~regex:(Regex {|\\.|})
            ~action:(Short "string.escape.invalid")
            ()
        ; Language_rule.mk
            ~regex:(Regex {|"|})
            ~action:
              (Language_action.mk_expanded
                 ~token:"string.quote"
                 ~bracket:"@close"
                 ~next:"@pop"
                 ())
            ()
        ] )
    ; ( "whitespace"
      , [ Language_rule.mk ~regex:(Regex {|[ \t\r\n]+|}) ~action:(Short "white") ()
        ; Language_rule.mk
            ~regex:(Regex {|\/\*|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@comment" ())
            ()
        ; Language_rule.mk ~regex:(Regex {|//.*$|}) ~action:(Short "comment") ()
        ] )
    ]
;;
