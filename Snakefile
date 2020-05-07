rule all:
    input:
        "data/sim-one.csv"

rule install_deps:
    input:
        "renv.lock"
    output:
        ".deps-installed"
    shell:
        """Rscript -e 'renv::restore();file.create(".deps-installed")'"""

rule sim:
    input:
        ".deps-installed",
        "data/sim.R"
    output:
        "data/sim-one.csv"
    shell:
        "Rscript data/sim.R"
