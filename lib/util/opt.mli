val iter : ('a -> unit) -> 'a option -> unit
(** [iter f o] if [o=Some x] then executes [f x]. *)

val map : ('a -> 'b) -> 'a option -> 'b option
(** [map f o] if [o=Some x] then returns [Some (f x)] otherwise returns None. *)

val map_default : 'a -> ('b -> 'a) -> 'b option -> 'a
(** [map_default d f o] if [o=Some x] then returns [(f x)] otherwise returns [d]. *)

val default : 'a -> 'a option -> 'a
(** [default d o] if [o=Some x] then returns [x] otherwise returns [d]. *)

val to_string : string option -> string
(** [to_string so] if [so=Some s] then returns [s] otherwise returns empty string.  *)

val of_string : string -> string option
(** [of_string s]
    If [ s <> "" ] then returns [Some s] otherwise returns [None].  *)
