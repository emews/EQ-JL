using PackageCompiler

import Pkg
Pkg.add("JLD")
Pkg.add("DataStructures")

create_sysimage([:JLD], sysimage_path="ext/EQ-JL/emews/worker.so")
