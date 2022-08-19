(* Copyright (c) 1998-2007 INRIA *)

open Config
open Def
open Gwdb

val cnt_dir : string ref
(** The directory where counters (e.g. number page displayed) are stored. *)

val image_prefix : config -> string
(** Returns the image prefix (conf.image_prefix)  *)

val base_path : string list -> string -> string
(** Alias for !GWPARAM.base_path *)

val bpath : string -> string
(** Alias for !GWPARAM.bpath *)

val search_in_assets : string -> string
(** Checks that the file in argument belong to one of the asserts dir
    (defined in the Secure module) *)

val include_begin : config -> string -> unit
val include_end : config -> string -> unit

val etc_file_name : config -> string -> string
(** Returns the path to the template file in parameter *)

val escache_value : base -> string
(** Returns the date of the base directory last update *)

val commit_patches : config -> base -> unit
(** Commits the patches and logs the modification *)

val update_wf_trace : config -> string -> unit

val get_referer : config -> string
(** Get referer (the page you came from to the current page) page from HTTP request *)

val no_html_tags : string -> string
val clean_html_tags : string -> string list -> string

val html : ?content_type:string -> config -> unit
(** Prints HTTP response headers with giving content type (default : {i text/html}) on the socket. *)

val unauthorized : config -> string -> unit
(** Prints HTTP response with code 401 (Unauthorized) and error page with giving message *)

val string_of_ctime : config -> string

val commd : config -> string
(** Returns link to the current command (database name after domain name and port in url) with query string
    that containts bindings from [conf.henv] and [conf.senv]. Doesn't add binding [(k,v)] when:
    - k = "oc" or "ocz" and v = "0"
    - v = "" *)

val commd_2 : config -> string
(** Same as [commd] but returns without separator '&' at the end. *)

val prefix_base : config -> string
val prefix_base_password : config -> string
val prefix_base_2 : config -> string
val prefix_base_password_2 : config -> string

val hidden_env : config -> unit
(** Creates a hidden HTML input for every key and value in [conf.henv] and [conf.senv].
    Used to include immutable environement bindings in the HTML form. *)

val nobtit : config -> base -> person -> title list
(** [nobtit conf base p] returns list of titles of [p] from the [base]
    that respects constraints imposed by [conf.allowed_titles] and
    [conf.denied_titles] *)

val strictly_after_private_years : config -> dmy -> bool

val authorized_age : config -> base -> person -> bool
(** Alias to !GWPARAM.p_auth *)

val is_old_person : config -> (iper, iper, istr) gen_person -> bool
val start_with_vowel : string -> bool

val acces_n : config -> base -> string -> person -> string
(** Returns URL query string to access nth person
    (e.g. for person 2 in url: p2=foo&n2=bar&oc2=1 *)

val acces : config -> base -> person -> string
val wprint_hidden_person : config -> base -> string -> person -> unit

val accessible_by_key : config -> base -> person -> string -> string -> bool
(** [accessible_by_key conf base p fn sn]
    Tells if person could be accessed by his first name and surname

    i.e. current base configuration and user rights allow this and
    person's name is suitable for searching by key (e.g. `? ?` is not)
*)

val geneweb_link : config -> string -> string -> string
(** [geneweb_link conf href s] Returns HTML link to actual geneweb's command (database name) with additional (to those defind by [commd])
    argument [href] and [s] as textual content of the link. *)

val wprint_geneweb_link : config -> string -> string -> unit
(** Prints on the socket link created by [geneweb_link]. *)

val is_restricted : config -> base -> iper -> bool
(** Tells if person is restrited to acccess. If mode `use_restrict` is
    disabled returns always [false]. *)

val is_hidden : person -> bool
(** Tells if person is hiden (if his surname is empty) *)

val pget : config -> base -> iper -> person
(** Returns person with giving id from the base.
    Wrapper around `Gwdb.poi` defined such as:
    - if `conf.use_restrict` (option defined in .gwf file):
      checks that the user has enought rights to see
      corresponding person (see `authorized_age`).
      If the user does not have enought permissions, returns
      an empty person.
    - just an alias to `Gwdb.poi` if `use_restrict` disabled.
*)

val string_gen_person :
  base -> (iper, iper, istr) gen_person -> (iper, iper, string) gen_person
(** Remplaces string ids inside person's entry by their actual string value. *)

val string_gen_family :
  base -> (iper, ifam, istr) gen_family -> (iper, ifam, string) gen_family
(** Remplaces string ids inside family's entry by their actual string value. *)

type p_access = (base -> person -> string) * (base -> person -> string)
(** Type that defines couple of functions
    returning someone's first name and surname.
    Typical use is to add some markup to a field, or systematically replace
    one by `""`.
*)

val std_access : p_access
(** Standard access (p_first_name, p_surname). *)

val raw_access : p_access
(** Raw access: same as `std_access` without the `Mutil.nominative` call. *)

val gen_person_text : p_access -> config -> base -> person -> string
(** Returns person's first name and surname HTML description depending on :
    - his public name
    - his qualifiers
  If person is hiden returns ".....". If person's names are hiden
  or access to them is denied returns "x x" *)

val gen_person_text_no_html : p_access -> config -> base -> person -> string
(** Same as [gen_person_text] but doesn't encapsulates description in HTML
    tag <em>. *)

val gen_person_text_without_title :
  p_access -> config -> base -> person -> string
(** Returns either person's first name and surname either title and qualifiers
    HTML description *)

val gen_person_title_text :
  (config -> base -> person -> string -> string) ->
  p_access ->
  config ->
  base ->
  person ->
  string
(** [gen_person_title_text reference paccess conf base p] returns HTML structure
    of person that describes person's first name surname and main title. [reference]
    is used to either encapsulate structure in the link (or other type
    of maniplations). *)

val person_text : config -> base -> person -> string
(** Makes call to [gen_person_text] with [std_access] *)

val person_text_no_html : config -> base -> person -> string
(** Makes call to [gen_person_text_no_html] with [std_access] *)

val person_text_without_surname : config -> base -> person -> string
(** Same as [gen_person_text] but doesn't display surname *)

val person_text_no_surn_no_acc_chk : config -> base -> person -> string
(** Same as [gen_person_text] but :
    - doesn't display surname
    - returns HTML description even if person's names are hiden
      or access to them is denied (don't print "x x") *)

val person_text_without_title : config -> base -> person -> string
(** Makes call to [gen_person_text_without_title] with [std_access] *)

val main_title : config -> base -> person -> title option
(** Returns main person's title. If person doesn't have it, then returns first title
    from the list. *)

val titled_person_text : config -> base -> person -> title -> string
(** Returns person's first name and surname text description depending on
    person's title *)

val one_title_text : base -> title -> string
(** Returns HTML representation of title's identifier with its place (if exists) *)

val person_title_text : config -> base -> person -> string
(** Returns HTML structure of person that describes person's first name surname
    and main title. Calls [gen_person_title_text] with [no_reference]. *)

val person_title : config -> base -> person -> string
(** Returns HTML representation of person's main title (or first title if
    main doesn't exists). If person doesn't have a title or if access to
    person isn't granted returns empty string *)

val child_of_parent : config -> base -> person -> string

val reference : config -> base -> person -> string -> string
(** [reference conf base p desc] returns HTML link to the person
    where [desc] is content of the link (generaly his first name and
    surname description). If person is hidden returns [desc] (do not
    create link). *)

val reference_noid : config -> base -> person -> string -> string
(** Same as [reference] but link doesn't has "id" field *)

val no_reference : config -> base -> person -> string -> string
(** [reference conf base p desc] returns [desc] without creating a link *)

val referenced_person_title_text : config -> base -> person -> string
(** Retruns HTML link to the person that contains its first name, surname and person's
    nobility title. Calls [gen_person_title_text] with [reference]. *)

val referenced_person_text : config -> base -> person -> string
(** Returns HTML link to the person that contains its first name and surname. *)

val referenced_person_text_without_surname : config -> base -> person -> string
(** Returns HTML link to the person that contains its first name. *)

val update_family_loop : config -> base -> person -> string -> string

val p_getenv : (string * string) list -> string -> string option
(** Returns value associated to the label in environnement *)

val p_getint : (string * string) list -> string -> int option
(** Returns integer value associated to the label in environnement *)

val create_env : string -> (string * string) list
(** Create association list from the query part of a URL.
    (i.e. a list of key-value separated by `&` or `;`)
*)

val open_etc_file : string -> (in_channel * string) option
(** [open_etc_file fname] search for template {i etc/fname.txt}
    inside the base directory or inside one of assets directories.
    Returns input channel and the path to giving template. *)

val open_hed_trl : config -> string -> in_channel option

val open_templ_fname : config -> string -> (in_channel * string) option
(** [open_etc_file fname] search for template {i etc/fname.txt}
    using [config] or inside one of assets directories.
    Returns input channel and the path to giving template. *)

val open_templ : config -> string -> in_channel option
(** Same as [open_templ_fname] but returns only input channel of the giving template file *)

val string_of_place : config -> string -> string
val place_of_string : config -> string -> place option
val allowed_tags_file : string ref

val body_prop : config -> string
(** Returns additional attributes for <body> tag from [config] (defined in .gwf file). *)

val message_to_wizard : config -> unit
(** Prints all messages sent to wizard (or friend) on the socket. Messages are located in
    {i <basename>/etc/mess_wizzard.txt} (messages destinated to all wizards) and in
    {i <basename>/etc/mess_wizzard_<user>.txt} (messages destinated to considered wizard). *)

val of_course_died : config -> person -> bool
val hexa_string : string -> string

val surname_particle : base -> string -> string
(** [surname_particle base sn]
    Extract the particle of [sn] if there is one.
    The list of particles to use is defined in [base]. *)

val surname_without_particle : base -> string -> string
(** [surname_without_particle base sn]
    Remove the particle of [sn] if there is one.
    The list of particles to use is defined in [base]. *)

val specify_homonymous : config -> base -> person -> bool -> unit

val get_approx_birth_date_place :
  config -> base -> person -> date option * string

val get_approx_death_date_place :
  config -> base -> person -> date option * string

type ('a, 'b) format2 = ('a, unit, string, 'b) format4

val check_format : ('a, 'b) format2 -> string -> ('a, 'b) format2 option
val valid_format : ('a, 'b) format2 -> string -> ('a, 'b) format2

val transl : config -> string -> string
(** Find translation of given keyword in [conf.lexicon].
    Keywords used to be its english translation but can be any string. *)

val transl_nth : config -> string -> int -> string
(** [transl_nth conf w n] translate word [w] and returns [n]'th field of its translation (with [nth_field]). *)

val transl_decline : config -> string -> string -> string
val ftransl : config -> ('a, 'b) format2 -> ('a, 'b) format2
val ftransl_nth : config -> ('a, 'b) format2 -> int -> ('a, 'b) format2
val fdecline : ('a, 'b) format2 -> string -> ('a, 'b) format2
val fcapitale : ('a, 'b) format2 -> ('a, 'b) format2

val nth_field : string -> int -> string
(** [nth_field str n] gets [n]'th field of string that separate its fields with "/".
    Example :
    - nth_field "a/b/</c>/d" 0 = a
    - nth_field "a/b/</c>/d" 1 = b
    - nth_field "a/b/</c>/d" 2 = </c>
    - nth_field "a/b/</c>/d" 3 = d *)

val cftransl : config -> string -> string list -> string
val translate_eval : string -> string

val transl_a_of_b : config -> string -> string -> string -> string
(** [transl_a_of_b conf a b b_raw]
    Translate "a of b" using [b_raw] for declension.
    i.e. if [b] is wrapped in html, [b_raw] should be that texte with no html,
    and [b_raw] should be [b] otherwise.
*)

val transl_a_of_gr_eq_gen_lev : config -> string -> string -> string -> string

val std_color : config -> string -> string
(** Colorise HTML element with [conf.highlight] color
    (wrap text in <span> with inline style). *)

val index_of_sex : sex -> int
(** Sex index used in translations (0 for male, 1 for female, 2 for neuter) *)

val string_of_pevent_name : config -> base -> istr gen_pers_event_name -> string

val string_of_fevent_name : config -> base -> istr gen_fam_event_name -> string
(** [string_of_fevent_name conf base fevent_name]
*)

val string_of_fevent : config -> base -> istr gen_fam_event_name -> string
(** [string_of_fevent conf base fevent_name]
*)

val string_of_witness_kind : config -> sex -> witness_kind -> string
(** [string_of_witness_kind conf sex wk]
    Return the string corresponding to wk according to [sex] and [conf].
*)

val relation_txt : config -> sex -> family -> (('a -> 'b) -> 'b, 'a, 'b) format
val string_of_decimal_num : config -> float -> string
val person_exists : config -> base -> string * string * int -> bool
val husband_wife : config -> base -> person -> bool -> string

val find_person_in_env : config -> base -> string -> person option
(** [find_person_in_env conf base suff]
    Reconstitutes the key of a person from [conf.env],
    using ["i" ^ suff] or ["n" ^ suff] + ["p" ^ suff] + ["oc" ^ suff]
*)

val find_person_in_env_pref : config -> base -> string -> person option
(** [find_person_in_env_pref conf base prefix]
    Same as [find_person_in_env] except that it uses a prefix
    instead of a suffix.
*)

(* Recherche le sosa uniquement dans le fichier gwf *)
val default_sosa_ref : config -> base -> person option
val find_sosa_ref : config -> base -> person option
val update_gwf_sosa : config -> base -> iper * (string * string * int) -> unit

val get_server_string : config -> string
(** Returns server host name with its port number (if different from 80). *)

val get_request_string : config -> string
(** Returns request string. Request string has format {i scriptname?querystring} where
    scriptname is a path to the script in URI. *)

val create_topological_sort : config -> base -> (iper, int) Gwdb.Marker.t

val p_of_sosa : config -> base -> Sosa.t -> person -> person option
(** [p_of_sosa conf base sosa p0]
    Get the sosa [sosa] of [p0] if it exists
*)

val branch_of_sosa : config -> base -> Sosa.t -> person -> person list option
(** [branch_of_sosa conf base sosa p0]
    Get all the lineage to go from [p0]'s ancestor with sosa number [sosa] to [p0]
*)

val sosa_of_branch : person list -> Sosa.t
(** [sosa_of_branch branch]
    Given a path of person to follow [branch], return the sosa number
    of the last person of this list. No check is done to ensure that
    given persons are actually parents.
*)

val old_branch_of_sosa :
  config -> base -> iper -> Sosa.t -> (iper * sex) list option
(** @deprecated Use [branch_of_sosa] instead *)

val old_sosa_of_branch : config -> base -> (iper * sex) list -> Sosa.t
(** @deprecated Use [sosa_of_branch] instead *)

val has_image : config -> base -> person -> bool

val image_file_name : string -> string
(** [image_file_name fname] search for image {i images/fname} inside the base and assets directories.
    Return the path to found file or [fname] if file isn't found.  *)

val source_image_file_name : string -> string -> string
(** Returns path to the image file with the giving name in directory {i src/}. *)

val image_size : string -> (int * int) option
(** Returns width and height of an image. *)

val limited_image_size :
  int -> int -> string -> (int * int) option -> (int * int) option
(** [limited_image_size max_wid max_hei fname defsize] returns image size of [fname]. If width and height are greater
    then their limits [max_wid] and [max_hei] then returns reduced size with the same proportions. [defsize] is returned
    if image filename is empty. *)

val image_and_size :
  config ->
  base ->
  person ->
  (string -> (int * int) option -> (int * int) option) ->
  (bool * string * (int * int) option) option
(** Returns path to the personal image. In details, returns [(is_filename,source,size)] where [is_filename] tells if [source]
    is a filename or URL and [size] is a size of image (width x height). *)

val default_image_name_of_key : string -> string -> int -> string
(** Returns default image name calculated from person's first name, surname
    and occurence number. For example : Jean Claude DUPOND 3 => jean_claude.3.dupond *)

val default_image_name : base -> person -> string
(** Returns default image name calculated from person's key. *)

val auto_image_file : config -> base -> person -> string option
(** Searchs personal image (portrait) inside the base directory by looking up its default name
    and tryig to deduce its extension. Returns path to the image if found. *)

val only_printable : string -> string
(** Trims and remplaces all non-printable characters by spaces in the given string. *)

val only_printable_or_nl : string -> string
(** Same as [only_printable] but also accepts '\n'. *)

val relation_type_text : config -> relation_type -> int -> string
val rchild_type_text : config -> relation_type -> int -> string
val has_nephews_or_nieces : config -> base -> person -> bool
val browser_doesnt_have_tables : config -> bool
val doctype : config -> string

val begin_centered : config -> unit
(** Prints on the socket beginning of the <table> tag untill first opened <td> where the text is centred *)

val end_centered : config -> unit
(** Prints on the socket end of the column and table opened by [begin_centered] *)

val print_alphab_list :
  config -> ('a -> string) -> ('a -> unit) -> 'a list -> unit

(* Printing for browsers without tables *)

val pre_text_size : string -> int
val print_pre_center : config -> int -> string -> unit
val print_pre_left : config -> int -> string -> unit
val print_pre_right : config -> int -> string -> unit
val short_f_month : int -> string

(* Reading password file *)

type auth_user = { au_user : string; au_passwd : string; au_info : string }
(** Authenticated user from from authorization file. *)

val read_gen_auth_file : string -> auth_user list
(** Read all authenticated users with their passwords from authorization file (associated to {i "wizard_passwd_file"} in [conf.base_env]) *)

val is_that_user_and_password : auth_scheme_kind -> string -> string -> bool
(** [is_that_user_and_password auth_sheme user paswd] verify if given user with his password correspond to the authentication scheme. *)

(* Searching *)

val in_text : bool -> string -> string -> bool
val html_highlight : bool -> string -> string -> string

(* Print list in columns with Gutil.alphabetic order *)

val wprint_in_columns :
  config -> ('a -> string) -> ('a -> unit) -> 'a list -> unit

val is_hide_names : config -> person -> bool
(** Tells if person's names are hiden (if person's access is [Private] or if mode [conf.hide_names] is enabled). *)

val reduce_list : int -> 'a list -> 'a list
(** [reduce_list n l] takes [n] first elements from the list [l] *)

val print_reference : config -> string -> int -> string -> unit

val gen_print_tips : config -> string -> unit
(** Print a tip with the specified text *)

val print_tips_relationship : config -> unit
(** Print a tip that tells to {i Click an individual below to calculate the family link.} *)

val print_image_sex : config -> person -> int -> unit
val display_options : config -> string

type cache_visited_t = (string, (iper * string) list) Hashtbl.t

val cache_visited : config -> string
val read_visited : config -> cache_visited_t
val record_visited : config -> iper -> unit

val array_mem_witn :
  Config.config ->
  Gwdb.base ->
  iper ->
  (iper * Def.witness_kind) array ->
  bool * string
(** [array_mem_witn conf base ip array] checks if [ip] is in [array]
    and returns corresponding [string_of_witness_kind] if so.
*)

val name_key : Gwdb.base -> string -> string
(** [name_key base name] is [name],
    with particles put at the end of the string instead of the beginning.
*)

val nb_char_occ : char -> string -> int
(** [nb_char_occ c s] return the number of times [c] appears in [s]. *)

val escape_html : string -> string
(** [escape_html str] replaces '&', '"', '\'', '<' and '>'
    with their corresponding character entities (using entity number) *)

val safe_html : string -> string
(**
   [safe_html s] sanitizes [s] element in order to fix ill-formed
   HTML input and to prevent XSS injection

   It removes any tag which is not allowed by geneweb.
   It removes all attributes starting with ["on"].
   It removes any attribute when the value starts with ["javascript"].
   Text is escaped using [escape_html].
 *)

val string_with_macros :
  config -> (char * (unit -> string)) list -> string -> string
(** [string_with_macros conf env s]
    Return a string with "%xxx" macro replaced by their value.
    Also filter unsafe html tags.
*)

val is_empty_name : person -> bool
(** [is_empty_name p]
    [false] if we knwon the first name or the last name of [p].
*)

module IperSet : sig
  include Set.S with type elt = iper
end

module IfamSet : sig
  include Set.S with type elt = ifam
end

(**/**)

val copy_from_templ_ref :
  (config -> (string * string) list -> in_channel -> unit) ref
(** Reference by default [Templ.copy_from_templ] *)
(* [copy_from_templ_ref] is for internal usage only. Use copy_from_templ *)

(**/**)

val include_template :
  config -> (string * string) list -> string -> (unit -> unit) -> unit
(** [include_template conf env fname failure]
    Search [fname] in templates path and interpret it with global environnement [env] provided.
    Interpretation of template write directly its results in the socket.
    If the file can not be found, [failure] is called.
*)

val select_masc :
  config -> base -> (iper * int) list -> (iper, int * person) Hashtbl.t
(** [select_masc conf base ips]
    From [ips], a list matching ipers to a number of maximum generations,
    get maximum ascendants of ipers up to these corresponding generations.

    A person is maximum ascendant if their generation matches the maximum, or
    if they do not have ancestors.

    The result is a Hashtbl matching an iper to the corresponding person and
    their generation.
*)

val select_desc :
  config -> base -> int -> (iper * int) list -> (iper, person) Hashtbl.t
(** [select_desc conf base gen_desc ips]
    From [ips], a list matching ipers to a number of maximum generations,
    get spouses and descendants of ipers up to these corresponding generations.
*)

val select_mascdesc :
  config -> base -> (iper * int) list -> int -> (iper, person) Hashtbl.t
(** [select_ascdesc conf base ips gen_desc]
    Get maximum ascendants with {!val:select_masc}, and get their desc with
    {!val:select_desc}
 *)

val sprintf_today : Config.config -> string
(** [sprintf_today confo]
    Uses {!val:Mutil.sprintf_date} in order to print datetime defined in [conf]. *)

val auth_warning :
  config -> base -> ('a, person, ifam, 'b, 'c, 'd, 'e) warning -> bool
(** [auth_warning conf base w]
    Check if current user has enough right in order to see [w] *)

val person_warnings : config -> base -> person -> CheckItem.base_warning list
(** [person_warnings conf base p]
    Shorthand for [CheckItem.person] and [CheckItem.on_person_update] on [p]
    and [CheckItem.check_siblings] on they children
    using [auth_warning] for filtering.
*)

val name_with_roman_number : string -> string option
(** Convert arabic numerals to roman numerals.
    [Some result] is returned if there are numerals, [None] if not.
*)

val cut_words : string -> string list
(** [cut_words str]
    Same output as
    [String.split_on_char ' ' s |> List.map String.trim |> List.filter ((<>) "")]
*)
