type opts

val config : ?base_url:string -> ?paths:(string * string) list -> unit -> unit
val require : string list -> (unit -> unit) -> unit
