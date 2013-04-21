open SupportDefs;;

type thread_id;;
type team_id;;

external b_threads_snooze : bigtime_t -> status_t = "b_threads_snooze"

let snooze ~t=
	b_threads_snooze t
