#!/bin/zsh

CONTENU=$(cat $1)



function changeContenu()
{
  TEMPCONTENU=$CONTENU
  CONTENU=$(echo -E $TEMPCONTENU | sed  "$1")
}

# Suprésison entière
changeContenu  "s/%.*$//"
changeContenu  "s/\\\\noindent{}//g"
changeContenu  "s/\\\\nopagebreak.4.//g"
changeContenu  "s/\\\\nopagebreak//g"
changeContenu  "s/\\\\vspace{[0-9]em}//g"
changeContenu  "s/\\\\begin{minipage}.t.{\\\\linewidth}//"
changeContenu  "s/\\\\end{minipage}//"
changeContenu  "s/\\\\small//g"
changeContenu  "s/\\\\footnotesize//g"
changeContenu  "s/\\\\scriptsize//g"
changeContenu  "s/\\\\tiny//g"
changeContenu  "s/\\\\ttfamily//g"
changeContenu  "s/\\\\RaggedRight//g"
changeContenu  "s/\\\\hfill//g"
changeContenu  "s/\\\\begin{quotation}//"
changeContenu  "s/\\\\end{quotation}//"
changeContenu  "s/\\\\begin{verse}//"
changeContenu  "s/\\\\end{verse}//"
changeContenu  "s/\\\\addcredit.*$//"
changeContenu  "s/\\\\addtocontents.*$//"

changeContenu  "s/\\\\endnote{\([^}]*\)}//g"
changeContenu  "s/\\\\footnote{\([^}]*\)}//g"
changeContenu  "s/\\\\phantom{\([^}]*\)}//g"
changeContenu  "s/\\\\restoregeometry//g"
changeContenu  "s/\\\\newgeometry{\([^}]*\)}//g"

# Suprésison du tag
changeContenu  "s/\\\\llap{\([^}]*\)}/\1/g"

changeContenu  "s/\\\\\\\\/<br \/>/"
changeContenu  "s/\\\\incise{\([^}]*\)}/(— \1 —)/g"
changeContenu  "s/\\\\emph{\([^}]*\)}/<em>\1<\/em>)/g"
changeContenu  "s/\\\\autonym{\([^}]*\)}/<em>\1<\/em>)/g"
changeContenu  "s/\\\\xenism{\([^}]*\)}/<em>\1<\/em>)/g"
changeContenu  "s/\\\\enquote{\([^}]*\)}/« \1 »/g"
changeContenu  "s/\\\\textsc{\([^}]*\)}/\1)/g"
changeContenu  "s/\\\\libertine{\([^}]*\)}/\1)/g"
changeContenu  "s/\\\\textarabic{\([^}]*\)}/\1)/g"

changeContenu  "s/\\\\em//g"

changeContenu  "s/\\\\elenaspeaks\({}\|\)/<br\/><b>Hélios. <\/b>/g"
changeContenu  "s/\\\\alexasspeaks\({}\|\)/<br\/><b>Imhotep. <\/b>/g"
changeContenu  "s/\\\\disciplespeaks\({}\|\)/<br\/><b>Disciple d’Imhotem. <\/b>/g"
changeContenu  "s/\\\\roispeaks\({}\|\)/<br\/><b>Agamemnon. <\/b>/g"
changeContenu  "s/\\\\reinespeaks\({}\|\)/<br\/><b>Cixi. <\/b>/g"
changeContenu  "s/\\\\princessespeaks\({}\|\)/<br\/><b>Freydis. <\/b>/g"
changeContenu  "s/\\\\suivantesspeaks\({}\|\)/<br\/><b>Suivantes de Freydis. <\/b>/g"
changeContenu  "s/\\\\suivanteprincessespeaks\({}\|\)/<br\/><b>Suivante de Freydis. <\/b>/g"
changeContenu  "s/\\\\vladimirspeaks\({}\|\)/<br\/><b>Assurbanipal. <\/b>/g"
changeContenu  "s/\\\\generalspeaks\({}\|\)/<br\/><b>Pyrgopolinice. <\/b>/g"
changeContenu  "s/\\\\nobleOnespeaks\({}\|\)/<br\/><b>Kazoku. <\/b>/g"
changeContenu  "s/\\\\nobleTwospeaks\({}\|\)/<br\/><b>Boyard. <\/b>/g"
changeContenu  "s/\\\\nobleTreespeaks\({}\|\)/<br\/><b>Teuctli. <\/b>/g"
changeContenu  "s/\\\\catinspeaks\({}\|\)/<br\/><b>Matahari. <\/b>/g"
changeContenu  "s/\\\\dariusspeaks\({}\|\)/<br\/><b>Darius. <\/b>/g"
changeContenu  "s/\\\\dariussuitespeaks\({}\|\)/<br\/><b>Suite de Darius. <\/b>/g"
changeContenu  "s/\\\\elaspeaks\({}\|\)/<br\/><b>Séléné. <\/b>/g"
changeContenu  "s/\\\\pagespeaks\({}\|\)/<br\/><b>Lieutenant. <\/b>/g"
changeContenu  "s/\\\\kingsgardsspeaks\({}\|\)/<br\/><b>Gardes royaux. <\/b>/g"
changeContenu  "s/\\\\choirspeaks\({}\|\)/<br\/><b>Chœur. <\/b>/g"
changeContenu  "s/\\\\maquerellespeaks\({}\|\)/<br\/><b>l’Entremetteuse. <\/b>/g"
changeContenu  "s/\\\\conspirateursspeaks\({}\|\)/<br\/><b>Soldats de la conspiration. <\/b>/g"
changeContenu  "s/\\\\greffierspeaks\({}\|\)/<br\/><b>Greffier. <\/b>/g"
changeContenu  "s/\\\\huissierspeaks\({}\|\)/<br\/><b>Huissier. <\/b>/g"
changeContenu  "s/\\\\chanteusespeaks\({}\|\)/<br\/><b>Chanteuse. <\/b>/g"
changeContenu  "s/\\\\impositeurspeaks\({}\|\)/<br\/><b>L’impositeur. <\/b>/g"
changeContenu  "s/\\\\medecinsspeaks\({}\|\)/<br\/><b>Médecins. <\/b>/g"
changeContenu  "s/\\\\medecinspeaks\({}\|\)/<br\/><b>Le médecin. <\/b>/g"
changeContenu  "s/\\\\chapelierspeaks\({}\|\)/<br\/><b>Le chapelier. <\/b>/g"
changeContenu  "s/\\\\cleopatrespeaks\({}\|\)/<br\/><b>Cléopâtre. <\/b>/g"
changeContenu  "s/\\\\pretrespeaks\({}\|\)/<br\/><b>Prêtre. <\/b>/g"
changeContenu  "s/\\\\peuplespeaks\({}\|\)/<br\/><b>Le peuple. <\/b>/g"
changeContenu  "s/\\\\speaker{\([^}]*\)}/<br\/><b>\1. <\/b>/g"


changeContenu  "s/\\\\campprincipal\({}\|\)/Babord/g"
changeContenu  "s/\\\\campoppose\({}\|\)/Tribord/g"
changeContenu  "s/\\\\elena\({}\|\)/Hélios/g"
changeContenu  "s/\\\\alexas\({}\|\)/Imhotep/g"
changeContenu  "s/\\\\disciple\({}\|\)/Disciple d’Imhotem/g"
changeContenu  "s/\\\\roi\({}\|\)/Agamemnon/g"
changeContenu  "s/\\\\reine\({}\|\)/Cixi/g"
changeContenu  "s/\\\\princesse\({}\|\)/Freydis/g"
changeContenu  "s/\\\\suivantes\({}\|\)/Suivantes de Freydis/g"
changeContenu  "s/\\\\suivanteprincesse\({}\|\)/Suivante de Freydis/g"
changeContenu  "s/\\\\vladimir\({}\|\)/Assurbanipal/g"
changeContenu  "s/\\\\general\({}\|\)/Pyrgopolinice/g"
changeContenu  "s/\\\\nobleOne\({}\|\)/Kazoku/g"
changeContenu  "s/\\\\nobleTwo\({}\|\)/Boyard/g"
changeContenu  "s/\\\\nobleTree\({}\|\)/Teuctli/g"
changeContenu  "s/\\\\catin\({}\|\)/Matahari/g"
changeContenu  "s/\\\\darius\({}\|\)/Darius/g"
changeContenu  "s/\\\\dariussuite\({}\|\)/Suite de Darius/g"
changeContenu  "s/\\\\ela\({}\|\)/Séléné/g"
changeContenu  "s/\\\\page\({}\|\)/Lieutenant/g"
changeContenu  "s/\\\\kingsgards\({}\|\)/Gardes royaux/g"
changeContenu  "s/\\\\choir\({}\|\)/Chœur/g"
changeContenu  "s/\\\\maquerelle\({}\|\)/l’Entremetteuse/g"
changeContenu  "s/\\\\conspirateurs\({}\|\)/Soldats de la conspiration/g"
changeContenu  "s/\\\\greffier\({}\|\)/Greffier/g"
changeContenu  "s/\\\\huissier\({}\|\)/Huissier/g"
changeContenu  "s/\\\\chanteuse\({}\|\)/Chanteuse/g"
changeContenu  "s/\\\\impositeur\({}\|\)/L’impositeur/g"
changeContenu  "s/\\\\medecins\({}\|\)/Médecins/g"
changeContenu  "s/\\\\medecin\({}\|\)/Le médecin/g"
changeContenu  "s/\\\\chapelier\({}\|\)/Le chapelier/g"
changeContenu  "s/\\\\cleopatre\({}\|\)/Cléopâtre/g"
changeContenu  "s/\\\\pretre\({}\|\)/Prêtre/g"
changeContenu  "s/\\\\peuple\({}\|\)/Le peuple/g"



changeContenu  "s/\\\\direct{\([^}]*\)}/(<em>\1<\/em>)/g"
changeContenu  "s/\\\\work{\([^}]*\)}/(<cite>\1<\/cite>)/g"

changeContenu  "s/\\\\sceneinfo.*$//"

changeContenu  "s/\\\\begin{drama}/<p>/"
changeContenu  "s/\\\\end{drama}/<\/p>/"

changeContenu  "s/\\\\StageDirII{\(.*\)}/<h5>\1<\/h5>/"
changeContenu  "s/\\\\StageDir{\(.*\)}/<h5><em>\1<\/em><\/h5>/"
changeContenu  "s/\\\\decors{\(.*\)}/<h5><em>\1<\/em><\/h5>/"
changeContenu  "s/\\\\intrat{\([^}]*\)}/<em>Intrat<\/em> \1.)/g"
changeContenu  "s/\\\\exit{\([^}]*\)}/<em>Exit<\/em> \1.)/g"
changeContenu  "s/\\\\exeunt{\([^}]*\)}/<em>Exeunt<\/em> \1.)/g"
changeContenu  "s/\\\\intrant{\([^}]*\)}/<em>Intrant<\/em> \1.)/g"
changeContenu  "s/<p>\n  <br\/>/<p>\r/g"
changeContenu  "s/\\\\switchcolumn.0.*/<em\/>/g"
changeContenu  "s/\\\\switchcolumn.1.*/ — /g"


TEMPCONTENU=$CONTENU
CONTENU=$(echo -E $TEMPCONTENU | awk '{
  for (i=1; i<=NF; i++) {
    if ($i == "\\scene") {
      $i = "<h3>Scène " ++count "<\/h3>"
    } else if ($i == "\\act") {
      count = 0
    }
  }
}1'
)

TEMPCONTENU=$CONTENU
CONTENU=$(echo -E $TEMPCONTENU | awk '{for (i=1; i<=NF; i++) if ($i == "\\act") $i = "<h2>Acte " ++count "</h2>"}1')



echo -E $CONTENU


