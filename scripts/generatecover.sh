#!/bin/zsh
OUTPUTDIR=output

SCRIPT_PATH=$(dirname "$(realpath "$0")")


SPINWIDTH=7mm
INPUTFILE=ascension-dhelios-skylab.pdf
pdftk $INPUTFILE cat r1 output /tmp/lastpage.pdf
pdftk $INPUTFILE cat  1 output /tmp/firstpage.pdf


xelatex -output-directory="${OUTPUTDIR}" -jobname=ascension-dhelios-skylab-FULLCOVER "\def\spinwidth{$SPINWIDTH} \input{${SCRIPT_PATH}/full-cover.tex}"

#pdftocairo -f 1 -l 1 -svg  damour-et-de-guerre-FULLCOVER.pdf temp.svg


