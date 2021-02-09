# Makefile syntax
# <target_file> : <dependency1> ...
# <TAB> command to produce target file

# If the dependencies or recipe need to take up more than one line, the line
# must be continued using a backslash.

all : lexicon.lexc \
	gen.hfstol \
	ana.hfstol \
	ana.png \
	lexicon.png

lexicon.lexc : root.lexc nouns.lexc verbs.lexc
	cat root.lexc nouns.lexc verbs.lexc > lexicon.lexc

gen.hfst : lexicon.lexc
	hfst-lexc <lexicon.lexc >gen.hfst

gen.hfstol : gen.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i gen.hfst -o gen.hfstol

ana.hfst : gen.hfst
	hfst-invert -i gen.hfst -o ana.hfst

ana.hfstol : ana.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i ana.hfst -o ana.hfstol

ana.png : ana.hfst
	hfst-fst2txt ana.hfst | python3 att2dot.py | dot -T png -o ana.png

lexicon.png : lexicon.lexc
	python3 lexc2dot.py <lexicon.lexc | dot -T png -o lexicon.png  # had a bug; fixed now?

.PHONY : clean
clean :
	-rm *.hfst *.hfstol lexicon.lexc