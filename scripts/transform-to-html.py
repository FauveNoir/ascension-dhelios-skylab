#from pylatexenc.latexwalker import LatexWalker, LatexEnvironmentNode
#
#w = LatexWalker(r"""
#\textbf{Hi there!} Here is \emph{a list}:
#\begin{enumerate}[label=(i)]
#\item One
#\item Two
#\end{enumerate}
#and $x$ is a variable.
#""")
#
#finalText=""" """
#
#for node in (nodelist, pos, len_) = w.get_latex_nodes(pos=0):
#    if macroname in node:
#        finalText.append("<truc>")
import pylatexenc.latexwalker as lw

# Votre texte LaTeX en entrée
latex_text = '\\section{Int \\bar{trala} roduction} Some text \\subsection{Subsection} More text.'

# Fonction récursive pour parcourir les nœuds et leurs nœuds intérieurs
def traverse_nodes(node):
    # Afficher le nœud en cours
    print("-")

    # Si c'est un nœud groupe (contenant des nœuds intérieurs), parcourir ses nœuds intérieurs
    #if isinstance(node, lw.LatexGroupNode) or isinstance(node, lw.LatexMacroNode) or isinstance(node, lw.LatexCharsNode):
    #if hasattr(node, "LatexGroupNode") or hasattr(node, "LatexMacroNode") or hasattr(node, "LatexCharsNode"):
#    if isinstance(node, lw.LatexGroupNode) or isinstance(node, lw.LatexMacroNode) or isinstance(node, lw.LatexCharsNode):
    if isinstance(node, lw.LatexMacroNode) :
        print("macro")
        print(dir(node))
        print(node.nodelist)
    if isinstance(node, lw.LatexCharsNode) :
        print("chars")
    if isinstance(node, lw.LatexGroupNode) :
        print("oui");
        print(dir(node))
        for subnode in node.nodelist:
            traverse_nodes(subnode)

# Analyser la structure syntaxique de la ligne LaTeX
parsed_nodes = lw.LatexWalker(latex_text).get_latex_nodes()

# Appeler la fonction de traversée pour chaque nœud de la nodeList

for node in parsed_nodes[0]:
    traverse_nodes(node)

