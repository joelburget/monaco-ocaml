type bracket =
  { close : string
  ; open_ : string
  ; token : string
  }

(* TODO *)
type regex = string

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
end

module Language_rule = struct
  type t =
    { regex : (string, regex) Either.t option
    ; action : Language_action.t option
    ; include_ : string option
    }

  let mk ?regex ?action ?include_ () = { regex; action; include_ }
end

(* TODO: indexable other keys, includeL *)
type t =
  { brackets : bracket list
  ; default_token : string
  ; ignore_case : bool
  ; start : string
  ; tokenizer : (string * Language_rule.t list) list
  }

let mk
    ?(brackets = [])
    ?(default_token = "source")
    ?(ignore_case = false)
    ?start
    tokenizer
  =
  let start =
    match start with None -> tokenizer |> List.hd |> fst | Some start -> start
  in
  { brackets; default_token; ignore_case; start; tokenizer }
;;

let example1 =
  mk
    [ ( "root"
      , [ Language_rule.mk ~regex:(Right {|\[error.*|}) ~action:(Short "custom-error") ()
        ; Language_rule.mk
            ~regex:(Right {|\[notice.*|})
            ~action:(Short "custom-notice")
            ()
        ; Language_rule.mk ~regex:(Right {|\[info.*|}) ~action:(Short "custom-info") ()
        ; Language_rule.mk
            ~regex:(Right {|\[[a-zA-Z 0-9:]+\]|})
            ~action:(Short "custom-date")
            ()
        ] )
    ]
;;

let example2 =
  mk
    [ ( "root"
      , [ Language_rule.mk
            ~regex:(Right {|[a-z_$][\w$]*|})
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
            ~regex:(Right {|[A-Z][\w\$]*|})
            ~action:(Short "type.identifier")
            ()
        ; Language_rule.mk ~include_:"@whitespace" ()
        ; Language_rule.mk
            ~regex:(Right {|@\s*[a-zA-Z_\$][\w\$]*|})
            ~action:
              (Language_action.mk_expanded
                 ~token:"annotation"
                 ~log:"annotation token: $0"
                 ())
            ()
        ] )
    ; ( "comment"
      , [ Language_rule.mk ~regex:(Right {|[^/*]+|}) ~action:(Short "comment") ()
        ; Language_rule.mk
            ~regex:(Right {|/*|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@push" ())
            ()
        ; Language_rule.mk
            ~regex:(Left {|\*/|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@pop" ())
            ()
        ; Language_rule.mk ~regex:(Right {|[/*]|}) ~action:(Short "comment") ()
        ] )
    ; ( "string"
      , [ Language_rule.mk ~regex:(Right {|[^\"]+|}) ~action:(Short "string") ()
        ; Language_rule.mk ~regex:(Right {|@escapes|}) ~action:(Short "string.escape") ()
        ; Language_rule.mk
            ~regex:(Right {|/\./|})
            ~action:(Short "string.escape.invalid")
            ()
        ; Language_rule.mk
            ~regex:(Right {|"|})
            ~action:
              (Language_action.mk_expanded
                 ~token:"string.quote"
                 ~bracket:"@close"
                 ~next:"@pop"
                 ())
            ()
        ] )
    ; ( "whitespace"
      , [ Language_rule.mk ~regex:(Right {|[ \t\r\n]+|}) ~action:(Short "white") ()
        ; Language_rule.mk
            ~regex:(Right {|\\*|})
            ~action:(Language_action.mk_expanded ~token:"comment" ~next:"@comment" ())
            ()
        ; Language_rule.mk ~regex:(Right {|\\/.*$|}) ~action:(Short "comment") ()
        ] )
    ]
;;
