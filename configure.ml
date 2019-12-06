(* ocaml ./configure.ml *)

#use "topfind" ;;
#require "unix" ;;

let strip = ref true
let rm = ref ""
let ext = ref ""
let os_type = ref ""

let installed pkg =
  0 = Sys.command ("ocamlfind query -qo -qe " ^ pkg)

let errmsg = "usage: " ^ Sys.argv.(0) ^ " [options]"

let api = ref false
let sosa = ref `None
let gwdb = ref `None

let set_api () = api := true

let set_sosa_legacy () = assert (!sosa = `None) ; sosa := `Legacy

let set_sosa_zarith () = assert (!sosa = `None) ; sosa := `Zarith

let set_sosa_num () = assert (!sosa = `None) ; sosa := `Num

let set_gwdb_legacy () = assert (!gwdb = `None) ; gwdb := `Legacy

let speclist =
  [ ( "--api"
    , Arg.Unit set_api
    , "Enable API support" )
  ; ( "--gwdb-legacy"
    , Arg.Unit set_gwdb_legacy
    , "Use legacy backend" )
  ; ( "--sosa-legacy"
    , Arg.Unit set_sosa_legacy
    , "Use legacy Sosa module implementation" )
  ; ( "--sosa-num"
    , Arg.Unit set_sosa_num
    , "Use Sosa module implementation based on `num` library" )
  ; ( "--sosa-zarith"
    , Arg.Unit set_sosa_zarith
    , "Use Sosa module implementation based on `zarith` library" )
  ]

let () =
  Arg.parse speclist failwith errmsg ;
  let dune_dirs_exclude = ref "" in
  let exclude_dir s = dune_dirs_exclude := !dune_dirs_exclude ^ " " ^ s in
  let api_d, api_pkg =
    match !api with
    | true -> "-D API", "piqirun.ext redis-sync yojson curl"
    | false -> "", ""
  in
  if !sosa = `None then begin
    if installed "zarith" then set_sosa_zarith ()
    else if installed "num" then set_sosa_num ()
    else set_sosa_legacy ()
  end ;
  let sosa_pkg =
    match !sosa with
    | `Legacy ->
      exclude_dir "sosa.num" ;
      exclude_dir "sosa.zarith" ;
      "geneweb-sosa"
    | `Num ->
      exclude_dir "sosa.array" ;
      exclude_dir "sosa.zarith" ;
      "geneweb-sosa-num"
    | `Zarith ->
      exclude_dir "sosa.array" ;
      exclude_dir "sosa.num" ;
      "geneweb-sosa-zarith"
    | `None -> assert false
  in
  let wserver_pkg = "geneweb-wserver" in
  let gwdb_d, gwdb_pkg =
    match !gwdb with
    | `None
    | `Legacy ->
      "-D GWDB1", "geneweb-gwdb-legacy geneweb-gwdb-legacy.internal"
  in
  let os_type, camlp5f, ext, rm, strip =
    match
      let p = Unix.open_process_in "uname -s" in
      let line = input_line p in
      close_in p ;
      line
    with
    | "Linux" | "Darwin" as os_type -> os_type, "", "", "/bin/rm -f", "strip"
    | _ -> "Win", " -D WINDOWS", ".exe", "rm -f", "true"
  in

  let ch = open_out "Makefile.config" in
  let writeln s = output_string ch @@ s ^ "\n" in
  let var name value = writeln @@ name ^ "=" ^ value in
  writeln @@ "# This file is generated by " ^ Sys.argv.(0)  ^ "." ;
  var "OS_TYPE" os_type ;
  var "STRIP" strip ;
  var "RM" rm ;
  var "EXT" ext ;
  var "API_D" api_d ;
  var "API_PKG" api_pkg ;
  var "GWDB_D" gwdb_d ;
  var "GWDB_PKG" gwdb_pkg ;
  var "SOSA_PKG" sosa_pkg ;
  var "WSERVER_PKG" wserver_pkg ;
  var "DUNE_DIRS_EXCLUDE" !dune_dirs_exclude ;
  close_out ch
