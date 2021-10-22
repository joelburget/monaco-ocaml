type opts = Jv.t

let obj () = Jv.get Jv.global "require"

let config ?base_url ?paths () =
  let opts = Jv.obj [||] in
  (match base_url with
  | None -> ()
  | Some base_url -> Jv.Jstr.set opts "baseUrl" (Jstr.v base_url));
  (match paths with
  | None -> ()
  | Some paths ->
    let paths =
      paths |> Array.of_list |> Array.map (fun (k, v) -> k, Jv.of_string v) |> Jv.obj
    in
    Jv.set opts "paths" paths);
  ignore @@ Jv.call (obj ()) "config" [| opts |]
;;

let require names cb =
  let names = Jv.of_list Jv.of_string names in
  ignore @@ Jv.apply (obj ()) [| names; Jv.repr cb |]
;;
