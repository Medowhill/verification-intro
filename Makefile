TEX := $(wildcard *.tex)
PDF := $(TEX:.tex=.pdf)

.PHONY: all clean

all: $(PDF)

%.pdf: %.tex
	latexmk -pdf -interaction=nonstopmode -halt-on-error $<

clean:
	latexmk -C
	$(RM) $(TEX:.tex=.nav) $(TEX:.tex=.snm)
