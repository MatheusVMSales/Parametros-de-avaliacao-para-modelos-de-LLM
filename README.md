# Métodos de avaliação de frases em português para selecionar parâmetros de avaliação de PLN gerado por LLM

Levantamento e caracterização de **onze métodos** de verificação automática de frases em
português brasileiro, aplicados a um mesmo corpus controlado de pares mínimos, e
encadeamento dos que sobrevivem à caracterização em uma **pipeline de quatro etapas**.

O problema de origem é prático: um sistema que redige frases a partir dos campos de uma base
de eventos de fogo produz texto **sem referência** — não há tradução de origem, resumo
humano nem gabarito —, de modo que métricas como BLEU e ROUGE não se aplicam e a verificação
recai sobre a frase isolada.

---

## Estrutura do repositório

```
.
├── aplicacao_tecnicas.ipynb    caderno-fonte: 52 células, os 11 métodos executados
├── artigo/                     o artigo em LaTeX (ver seção "O artigo")
├── escopo_artigo.md            planejamento da conversão caderno → artigo
├── pt_br_full.txt              lista de frequências (FrequencyWords 2018, pt_br)
└── material_suporte/           estudos anteriores e bibliografia de apoio
    ├── estudo.tex              relatório anterior, 16 técnicas (fonte do estilo LaTeX)
    ├── estudo_tecnicas_avaliacao.ipynb
    ├── avaliacao_de_frases.ipynb
    ├── justificativa_pipeline.ipynb
    ├── Avaliação_de_PLN.pdf
    └── 2304.09848v2.pdf
```

---

## O corpus

Uma frase de referência, redigida a partir dos campos de um registro de eventos de fogo:

> **Há três dias o incêndio atingiu uma área de mata nativa.**

Dela derivam doze variantes, cada uma com um único desvio de tipo conhecido. O desvio não
precisa ser anotado porque foi **introduzido**.

| Variante | Nível afetado | Alteração |
|---|---|---|
| `natvia` | ortografia | forma inexistente no léxico |
| `A três dias` | escolha lexical | forma existente, mas inadequada |
| `uma áreas` | concordância nominal | determinante × núcleo |
| `a área inteiro` | concordância nominal | adjetivo posposto |
| `os incêndios atingiu` | concordância verbal | sujeito nominal × verbo |
| `cantou` | semântica | restrição de seleção violada |
| `que atingiu` | estrutura | relativa sem oração principal |
| `Atingir…` | estrutura | infinitivo isolado |
| ordem embaralhada | ordem | as onze palavras permutadas |
| `tres` + `áreas` + `natvia` | múltiplo | três desvios simultâneos |
| `destruiu` | — | **controle**: paráfrase plausível |
| `O incêndio é intenso` | — | **controle**: predicação nominal |

Mais seis frases auxiliares: dois pares de complexidade sintática, um par de comprimento de
dependência e um par de permutação. São necessárias porque os descritores só se distinguem
quando o comprimento é mantido fixo.

**Alcance.** O corpus sustenta afirmações qualitativas — que um método detecta ou não
determinado desvio, e por qual mecanismo. Não sustenta precisão, revocação ou desempenho
comparativo.

---

## Os onze métodos

Distribuídos por quatro dimensões, cada uma pressupondo a anterior.

| # | Método | Dimensão | Devolve | Recurso |
|---|---|---|---|---|
| 1 | Léxico com distância de edição | ortografia | veredito **exato** + correção | `pt_br_full.txt` |
| 2 | Traços morfossintáticos na árvore | gramática | tripla `(t, h, τ)` localizada | spaCy |
| 3 | Regras escritas à mão | gramática | regra + norma em português | LanguageTool |
| 4 | SLOR | gramática | número por frase | mac_morpho |
| 5 | PLL | gramática | número por frase | BERTimbau |
| 6 | Teste do núcleo predicativo | estrutura | veredito binário localizado | spaCy |
| 7 | Índices de complexidade sintática | estrutura | perfil de três números | spaCy |
| 8 | Comprimento de dependência e $X$ | estrutura | dois números por frase | spaCy |
| 9 | Surpresa por token | semântica | um valor por palavra | mac_morpho |
| 10 | Plausibilidade do verbo mascarado | semântica | margem + formas esperadas | spaCy + BERTimbau |
| 11 | Embeddings | semântica | cosseno por par | spaCy |

---

## A pipeline

Quatro dos onze métodos, na ordem que decorre das dimensões: uma palavra fora do léxico
deforma a árvore que as etapas seguintes leem, e o verbo mascarado devolve `n/a` quando a
raiz não é verbo.

```
1. ortografia  →  2. estrutura  →  3. gramática  →  4. semântica
   léxico          raiz finita      traços μ̂         verbo mascarado
```

Três ajustes foram incorporados a partir do que a caracterização revelou: exigência de verbo
**finito** na raiz, comparação de gênero no particípio passivo, e tratamento do numeral por
valor.

**O veredito decorre da vacuidade de um conjunto:**

$$\mathrm{Loc}(s) = E_1 \cup E_2 \cup E_3 \cup E_4 \qquad \mathrm{Loc}(s) \neq \varnothing \Rightarrow \text{frase reprovada}$$

Nenhum valor é somado, ponderado ou confrontado com limiar agregado. Existe **um único
parâmetro calibrável** em toda a cadeia — o $\theta = 5{,}0$ nats da etapa semântica — e ele
decide apenas a admissão daquele achado, sem participar do veredito.

**O que a pipeline não cobre.** A escolha lexical (*A três dias* atravessa as quatro etapas
sem detecção; é exatamente o caso que as regras escritas à mão pegam) e o erro factual
(*A área cresceu de 1.284 para 340 hectares* é português correto e falso apenas em relação
à base).

---

## Recursos e versões

Nenhum modelo foi treinado ou ajustado. Todos são de prateleira, e os limites observados
pertencem a eles, não aos métodos.

| Recurso | Versão | Fornece | Escala |
|---|---|---|---|
| `pt_br_full.txt` | 2018 | léxico e frequências | 137.523 formas (*f* ≥ 20), *N* = 424.015.479 |
| mac_morpho (NLTK) | — | contagens de uni e bigrama | 1.012.661 palavras, 51.115 frases |
| spaCy `pt_core_news_md` | 3.8 | árvore, traços e vetores | vetores 20.000 × 300 |
| BERTimbau *base cased* | — | modelo mascarado | vocabulário de 29.794 |
| LanguageTool pt-BR | 6.6 | regras escritas à mão | 2.270 regras, 249 grupos |

---

## O artigo

```
artigo/
├── main.tex              preâmbulo, capa, resumo, \input das seções
├── 01-introducao.tex
├── 04-metodologia.tex    corpus, protocolo, as quatro dimensões
├── 05-metodos.tex        \section{Os métodos} + \input dos onze
├── m01-lexico.tex … m11-embeddings.tex
├── 06-resultados.tex     a pipeline, com o percurso matemático completo
├── referencias.bib       21 entradas (18 citadas)
└── compilar.sh
```

Estado atual: **16 páginas, ~8.000 palavras, 35 equações, 14 tabelas.**

### Compilar

```bash
cd artigo
./compilar.sh          # ciclo completo (latexmk + biber)
./compilar.sh rapido   # uma passada, sem bibliografia
./compilar.sh limpar   # remove auxiliares
```

O script reporta erros com arquivo e linha e lista referências pendentes.

### Ambiente LaTeX

TeX Live 2026 instalado **na home, sem root**, em `~/texlive/2026`. O PATH já está no
`~/.bashrc`. Para reinstalar em outra máquina:

```bash
curl -sSL -o install-tl.tar.gz https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl.tar.gz && cd install-tl-*
./install-tl --no-interaction --scheme=scheme-basic --texdir="$HOME/texlive/2026"
export PATH="$HOME/texlive/2026/bin/x86_64-linux:$PATH"
tlmgr install amscls amsfonts amsmath babel-english babel-portuges hyphen-portuguese \
  etoolbox iftex ifplatform etex-pkg lm url microtype csquotes booktabs multirow float \
  xcolor tools pgf tikz-dependency listings hyphenat geometry hyperref environ trimspaces \
  biblatex biblatex-abnt biber logreq xstring latexmk
```

> Se o mirror sorteado falhar (acontece), fixe um confiável antes de instalar:
> `tlmgr option repository https://ctan.math.illinois.edu/systems/texlive/tlnet`

### Convenções de escrita

- **Registro acadêmico, prosa corrida.** Sem `\paragraph{}` com títulos em forma de
  pergunta, sem perguntas retóricas. Verbos impessoais, conectivos explícitos, tabelas
  anunciadas no texto.
- **Curto e direto.** Cada seção é escrita já enxuta. A migração caderno → artigo é
  trabalho de **compressão**: o caderno tem ~20 mil palavras.
- **Notação única.** As macros (`\sent`, `\lexico`, `\raiz`, `\tracos`, `\tracosp`, `\SLOR`…)
  estão centralizadas no preâmbulo do `main.tex`. O caderno usa doze notações locais; o
  artigo usa uma.
- **Estrutura plana.** Todos os `.tex` na raiz de `artigo/`, sem subpastas — o upload avulso
  do Overleaf sempre cai na raiz.

---

## Estado e pendências

### Escrito
- [x] Capa, resumo e palavras-chave
- [x] §1 Introdução
- [x] §2 Metodologia (corpus, protocolo, dimensões)
- [x] §3 Os métodos — os onze
- [x] §4 Resultados — a pipeline, com percurso matemático

### A escrever
- [ ] Resultados, segunda parte: as **análises de degeneração**. Cinco ponteiros já apontam
      para lá, deixados nos métodos 2, 7, 8, 9 e 11.
- [ ] Discussão e ameaças à validade
- [ ] Conclusão
- [ ] Trabalhos relacionados e Preliminares/notação (previstos no escopo, ainda não abertos)
- [ ] Apêndices: código, tabelas de derivação, protocolo

### Decisões em aberto
- **Cinco ou seis proposições.** Há uma sexta derivada e verificada numericamente:
  $\mathrm{SLOR}(s) \geq \ln(1-\lambda)$ para toda frase, o que faz de $\ln(1-\lambda)$ o
  **mínimo global** da medida, e não apenas o valor do caso degenerado. Com $\lambda = 0{,}7$
  o piso é $-1{,}204$, e a frase embaralhada do corpus ($-1{,}000$) está a 83% dele.
- **Limite de páginas / veículo.** Ainda não fixado, e determina quanto do material cabe.
- **Exclusão do LanguageTool da pipeline** não tem motivo registrado no caderno, embora ele
  detecte um caso que a cadeia não pega.

### Ressalvas conhecidas
- **Procedência dos números.** Boa parte dos valores citados no caderno (contagens de regras
  do LanguageTool, `morph_acc`/`dep_las` do spaCy, distribuições top-*k* do BERTimbau,
  tabelas de norma dos vetores) aparece apenas no markdown, **sem célula que os produza**.
  Os que foram conferíveis localmente batem exatamente; o problema é de reprodutibilidade,
  não de exatidão.
- **A pipeline foi ajustada no mesmo corpus em que é avaliada.** Os três ajustes derivam
  cada um de uma falha observada nessas frases. Não há conjunto reservado.
- **Entradas bibliográficas** foram redigidas a partir das âncoras do escopo; onze estão
  marcadas `% VERIFICAR páginas` no `referencias.bib`.
