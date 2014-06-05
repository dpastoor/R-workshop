# You want latexmk to *always* run, because make does not have all the info.
.PHONY: 

handout_knitr_files = workshop_handout.Rnw

output_files = $(addsuffix .pdf, $(basename $(handout_knitr_files)))

# First rule should always be the default "all" rule, so both "make all" and
# "make" will invoke it.
all: $(output_files)

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# '$<' is a variable holding the (first) dependency, and '$*' is a variable
# holding the string matching '%' of a rule.

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interactive=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

%.pdf: %.Rnw
	echo 'library(knitr); knit2pdf("workshop_handout.Rnw")' | R --no-save
