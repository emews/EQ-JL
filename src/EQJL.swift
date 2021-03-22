/*
   EMEWS EQJL.swift
*/

import location;
pragma worktypedef resident_work;

@dispatch=resident_work
(void v) _void_jl(string code) "turbine" "0.1.0"
    [ "julia::eval <<code>>"];

@dispatch=resident_work
(string output) _string_jl(string code) "turbine" "0.1.0"
    [ "set <<output>> [ julia::eval <<code>>]" ];

string init_package_string = "push!(LOAD_PATH, \"%s/ext/EQ-JL/emews\");include(\"%s/julia/%s.jl\"); using .%s";
(void v) EQJL_init_package(location loc, string path, string module){
    printf("EQJL_init_package ...");
    string code = init_package_string % (path, path, module, module);
    printf("EQJL_init_package code is: \n%s;", code);
    @location=loc _void_jl(code) => v = propagate();
}

(void v)
EQJL_stop(location loc){
    // do nothing but set the void
    v = propagate();
}

string get_string = "result = eqjl.output_get()";

(string result) EQJL_get(location loc){
    string code = get_string;
    // printf("EQJL_get: \n%s", code);
    result = @location=loc _string_jl(code);
}

string put_string = "push!(eqjl.input_q, \"%s\");";

(void v) EQJL_put(location loc, string data){
    string code = put_string % data;
    // printf("EQJL_put code: \n%s", code);
    @location=loc _string_jl(code) => v = propagate();
}