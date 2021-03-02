import io;
import sys;
import files;
import location;
import string;
import assert;
import julia;
import unix;
import stats;

import EQJL;
import JLMap;

string emews_root = getenv("EMEWS_PROJECT_ROOT");
string turbine_output = getenv("TURBINE_OUTPUT");
string resident_work_ranks = getenv("RESIDENT_WORK_RANKS");
string r_ranks[] = split(resident_work_ranks,",");
string algo_params = argv("algo_params");
string module = argv("module");

(void v) loop(location ME) {
    printf("workflow.swift loop start");
    for (boolean b = true, int i = 1;
       b;
       b=c, i = i + 1)
    {
        payload_str = EQJL_get(ME);
        printf("workflow.swift payload_str: %s", payload_str);
        string payload[] = split(payload_str, "|");
        string payload_type = payload[0]; //jlmap
        boolean c;

        if (payload_type == "DONE") {
            string finals =  EQJL_get(ME);
            printf("workflow.swift Results: %s", finals) =>
            v = make_void() =>
            c = false;

        } else if (payload_type == "EQJL_ABORT") {
            printf("EQ-JL aborted: see output for error") =>
            string why = EQJL_get(ME);
            printf("%s", why) =>
            v = propagate() =>
            c = false;
        } else if (payload_type == "jlmap") {
            printf("workflow.swift run_jlmap()") =>
            string jlmap_result[] = run_jlmap(payload);
            EQJL_put(ME, join(jlmap_result, ";")) => c = true;
        }
    }
}


(void o) start (int ME_rank) {
    printf("workflow.swift starting");
    location deap_loc = locationFromRank(ME_rank);
    EQJL_init_package(deap_loc, emews_root, module) =>
    EQJL_get(deap_loc) =>
    EQJL_put(deap_loc, algo_params) =>
    loop(deap_loc) => {
        EQJL_stop(deap_loc);
        o = propagate();
    }
}

// deletes the specified directory
app (void o) rm_dir(string dirname) {
    "rm" "-rf" dirname;
}

main() {

    assert(strlen(emews_root) > 0, "Set EMEWS_PROJECT_ROOT!");

    int ME_ranks[];
    foreach r_rank, i in r_ranks {
      ME_ranks[i] = toint(r_rank);
    }

    foreach ME_rank, i in ME_ranks {
    start(ME_rank) =>
        printf("End rank: %d", ME_rank);
    }
}
