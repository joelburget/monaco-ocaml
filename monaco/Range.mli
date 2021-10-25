type t

val to_jv : t -> Jv.t
val of_jv : Jv.t -> t
val collapse_to_start : t -> t
val contains_position : t -> Position.t -> bool
val contains_range : t -> t -> bool
val equals_range : t -> t -> bool
val get_end_position : t -> Position.t
val get_start_position : t -> Position.t
val intersect_ranges : t -> t -> t
val is_empty : t -> bool
val plus_range : t -> t -> t
val set_end_position : t -> int -> int -> t
val set_start_position : t -> int -> int -> t
val strict_contains_range : t -> t -> bool
val to_string : t -> string
val are_intersecting : t -> t -> bool
val are_intersecting_or_touching : t -> t -> bool

(* val collapse_to_start : t -> t *)
val compare_ranges_using_ends : t -> t -> int
val compare_ranges_using_starts : t -> t -> int

(* val contains_position : t -> Position.t -> bool *)
(* val contains_range : t -> t -> bool *)
(* val equals_range : t -> t -> bool *)
val from_positions : Position.t -> Position.t -> t
(* val get_end_position : t -> Position.t *)
(* val get_start_position : t -> Position.t *)
