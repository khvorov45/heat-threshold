rule all:
    input:
        "data-plot/sim-one-temp.pdf",
        "data-plot/sim-one-deaths.pdf",
        "data-plot/sim-one-xy.pdf",
        "pred-plot/preds-glm-sim-one.pdf",
        "pred-plot/preds-gam-sim-one.pdf"

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
        "data-plot/sim-one-temp.pdf",
        "data-plot/sim-one-deaths.pdf",
        "data-plot/sim-one-xy.pdf"
    shell:
        "Rscript data-plot/data-plot.R"

rule fit:
    input:
        ".deps-installed",
        "model-fit/fit.R",
        "data/sim-one.csv"
    output:
        "model-fit/preds-glm-sim-one.csv",
        "model-fit/preds-gam-sim-one.csv"
    shell:
        "Rscript model-fit/fit.R"

rule pred_plot:
    input:
        ".deps-installed",
        "pred-plot/pred-plot.R",
        "model-fit/preds-glm-sim-one.csv",
        "model-fit/preds-gam-sim-one.csv"
    output:
        "pred-plot/preds-glm-sim-one.pdf",
        "pred-plot/preds-gam-sim-one.pdf"
    shell:
        "Rscript pred-plot/pred-plot.R"
