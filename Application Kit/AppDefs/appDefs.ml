external kb_about_requested : unit -> int32 = "kb_about_requested"
external kb_quit_requested : unit -> int32 = "kb_quit_requested"
external kb_key_down : unit -> int32 = "kb_key_down"

let kB_ABOUT_REQUESTED = kb_about_requested ();;
let kB_QUIT_REQUESTED = kb_quit_requested ();;
let kB_KEY_DOWN = kb_key_down () ;;
