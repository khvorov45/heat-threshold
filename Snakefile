rule all:
    input:
        "data-plot/sim-one-temp.pdf"

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

rule data_plot:
    input:
        ".deps-installed",
        "data-plot/data-plot.R",
        "data/sim-one.csv"
    output:
        "data-plot/sim-one-temp.pdf"
    shell:
        "Rscript data-plot/data-plot.R"
