#!/usr/bin/env bash
# =====================================================================
#  Compila o artigo com pdfLaTeX + Biber (latexmk cuida das passadas).
#  Uso:  ./compilar.sh          compilação completa
#        ./compilar.sh rapido   uma passada, sem bibliografia
#        ./compilar.sh limpar   remove auxiliares
# =====================================================================
set -u
cd "$(dirname "$0")"
export PATH="$HOME/texlive/2026/bin/x86_64-linux:$PATH"

LOG=.compilar.out

case "${1:-completo}" in
  limpar)
    latexmk -C >/dev/null 2>&1
    rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.run.xml *.toc *.fls *.fdb_latexmk "$LOG"
    echo "auxiliares removidos"; exit 0 ;;
  rapido)
    pdflatex -interaction=nonstopmode -file-line-error main.tex >"$LOG" 2>&1 ;;
  *)
    latexmk -pdf -interaction=nonstopmode -file-line-error main.tex >"$LOG" 2>&1 ;;
esac
RC=$?

if [ ! -f main.pdf ] || [ $RC -ne 0 ]; then
  echo "FALHOU (rc=$RC). Erros de LaTeX:"
  grep -E "^(!|.*:[0-9]+:)" main.log 2>/dev/null | grep -v "^!  ==>" | head -15
  echo
  echo "log completo em: $(pwd)/main.log   (saída do latexmk: $LOG)"
  exit 1
fi

PAGS=$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')
echo "OK  ->  main.pdf${PAGS:+  ($PAGS páginas)}"

# pendências que importam enquanto o artigo está sendo montado
REFS=$(grep -o "Reference \`[^']*'" main.log | sort -u)
CITS=$(grep -oE "citation '[^']*'" main.log | sort -u)
if [ -n "$REFS$CITS" ]; then
  echo
  echo "pendentes (esperado enquanto há seções por escrever):"
  [ -n "$REFS" ] && echo "$REFS" | sed 's/^/  ref  /'
  [ -n "$CITS" ] && echo "$CITS" | sed 's/^/  cite /'
fi
