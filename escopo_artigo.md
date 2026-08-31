# Escopo — conversão de `aplicacao_tecnicas.ipynb` em artigo LaTeX

Documento de planejamento. Define o gênero do artigo, a estrutura de seções, o que
migra de cada célula do caderno, o que precisa ser escrito do zero, e a infraestrutura
LaTeX.

---

## 1. Diagnóstico do material

### Volume atual

| seção | palavras | fórmulas | linhas de tabela | blocos de código |
|---|---:|---:|---:|---:|
| 1 Léxico | 1.539 | 12 | 23 | 1 |
| 2 Traços | 1.356 | 6 | 32 | 2 |
| 3 Regras | 1.666 | 8 | 19 | 6 |
| 4 SLOR | 1.957 | 11 | 51 | 2 |
| 5 PLL | 1.902 | 5 | 36 | 5 |
| 6 Raiz | 1.685 | 8 | 8 | 2 |
| 7 Complexidade | 1.441 | 9 | 28 | 1 |
| 8 Dependência | 1.494 | 9 | 26 | 3 |
| 9 Pipeline | 1.433 | 12 | 26 | 5 |
| 10 Surpresa | 1.482 | 10 | 16 | 2 |
| 11 Verbo mascarado | 1.958 | 8 | 31 | 2 |
| 12 Embeddings | 1.922 | 9 | 20 | 3 |
| **total** | **19.835** | **107** | **316** | **34** |

≈ **40 páginas A4** de corpo de texto. Artigo de conferência nacional (SBC) admite
12–14; revista admite 20–35.

### O corpus experimental

O caderno emprega **uma sentença de referência** e **12 perturbações controladas**:

```
referência:  Há três dias o incêndio atingiu uma área de mata nativa.

perturbações:
  natvia                    grafia (forma inexistente)
  A três dias               escolha lexical (forma existente, inadequada)
  uma áreas                 concordância nominal (det × núcleo)
  a área inteiro            concordância nominal (adjetivo pós-nominal)
  os incêndios atingiu      concordância verbal (sujeito nominal)
  cantou                    restrição de seleção (anomalia semântica)
  destruiu                  paráfrase plausível (controle negativo)
  que atingiu               fragmento (relativa sem principal)
  Atingir…                  fragmento (infinitivo isolado)
  É intenso                 predicação nominal (controle de cópula)
  ordem embaralhada         permutação total
  tres + áreas + natvia     desvios múltiplos (entrada da pipeline)
```

Mais 6 sentenças auxiliares para as seções 7, 8 e 12 (pares de complexidade, de
comprimento de dependência e de permutação).

**Isto é um desenho de pares mínimos direcionados** — o mesmo paradigma de Linzen et al.
(2016), Marvin & Linzen (2018) e BLiMP (Warstadt et al., 2020). Não é fragilidade
metodológica; é um método com nome e literatura. Mas está em **escala insuficiente**
para reportar desempenho (ver §6).

### Os dois tipos de resultado

A distinção mais importante para a estrutura do artigo:

**(A) Resultados analíticos** — identidades demonstradas, independentes de dados:

1. $\mathrm{ramif}(s) = (n-1)/n$ — a ramificação média não é função da árvore
2. $c(w_{i-1},w_i)=0 \Rightarrow \mathrm{contrib}_i = \ln(1-\lambda)$ — degeneração do SLOR
3. sobre $Z$, $\arg\max_i \mathrm{surp}(w_i) = \arg\min_i c(w_i)$ — o pico é a forma mais rara
4. $\mathbf{v}(\pi(s)) = \mathbf{v}(s)$ — invariância da média a permutações
5. árvore com todos os nós dependentes da raiz $\Rightarrow X(s)=0$ — projetividade forçada

**(B) Resultados empíricos** — observados nos pares mínimos:

- o analisador normaliza o desvio antes da regra ($\hat\mu_{\text{Gender}}(\texttt{inteiro})=\texttt{Fem}$)
- a linguagem de padrões do LanguageTool não alcança sujeito nominal
- o PLL imputa o custo do desvio à posição não alterada
- o pico de surpresa recai sobre o verbo correto da sentença de referência
- antônimos apresentam cosseno superior ao de sinônimos

**(A) sustenta o artigo sozinho.** São proposições, não medições — não precisam de
corpus maior. **(B) precisa de expansão** para virar afirmação quantitativa.

---

## 2. Gênero e veículo — decisão a tomar antes de escrever

| opção | extensão | o que exige | o que preserva |
|---|---|---|---|
| **(I) Artigo de revista** *(recomendado)* | 22–30 pág | expandir corpus (§6); escrever §§ 2–3 | tudo, inclusive as 5 proposições com demonstração |
| (II) Artigo de conferência | 12–14 pág | compressão 3×; cortar 5 das 11 técnicas | só a pipeline e 2–3 proposições |
| (III) Dois artigos | 14 + 14 | dois ciclos de submissão | A: caracterização formal · B: pipeline aplicada |

**Recomendação: (I).** O material é denso e verificado; comprimir a 12 páginas
obrigaria a descartar as demonstrações, que são a parte mais original. Veículos
compatíveis: *Linguamática*, *Journal of the Brazilian Computer Society*, *Revista de
Informática Teórica e Aplicada (RITA)*, ou *Natural Language Engineering* (se
traduzido).

O restante deste escopo assume a opção (I).

---

## 3. Tese do artigo

Enunciada em uma frase, para orientar todos os cortes:

> **Nem toda medida numérica definida sobre texto constitui um detector de desvio.**
> Sob um formalismo comum, caracterizam-se onze técnicas de verificação automática para
> o português; demonstra-se analiticamente que quatro delas degeneram — duas em
> constantes independentes da sentença — e deriva-se, do que sobrevive à
> caracterização, uma pipeline de quatro etapas cujo veredito não depende de limiar
> agregado.

Tudo o que não serve a essa tese é candidato a corte.

---

## 4. Estrutura de seções

### 1. Introdução — ~1,5 pág · **escrever do zero**

- Contexto de aplicação: geração de relatórios a partir de base de eventos de fogo;
  necessidade de verificar automaticamente a sentença produzida.
- Problema: a literatura oferece medidas heterogêneas — simbólicas, probabilísticas,
  distribucionais — e o critério de escolha entre elas raramente é explicitado.
- Observação motivadora: medidas **descritivas** (complexidade sintática, comprimento de
  dependência, similaridade distribucional) são recorrentemente empregadas como
  **detectores**, emprego que este trabalho mostra ser inválido por construção.
- Contribuições, enumeradas:
  1. formalismo comum e taxonomia para onze técnicas heterogêneas;
  2. cinco proposições que caracterizam analiticamente os modos de degeneração;
  3. matriz de cobertura técnica × tipo de desvio sobre pares mínimos controlados;
  4. pipeline de quatro etapas com veredito por vacuidade de conjunto;
  5. artefato reprodutível com versões fixadas de todos os recursos.
- Organização do artigo.

### 2. Trabalhos relacionados — ~2,5 pág · **escrever do zero** (lacuna total no caderno)

Cinco blocos, com as âncoras mínimas:

| bloco | referências mínimas |
|---|---|
| Correção ortográfica por distância de edição | Levenshtein (1966); Damerau (1964); Kukich (1992) |
| Verificação gramatical por regras | Naber (2003); Miłkowski (2010) — LanguageTool |
| Aceitabilidade por modelo de linguagem | Pauls & Klein (2012); Lau, Clark & Lappin (2015) — SLOR; Wang & Cho (2019), Salazar et al. (2020) — PLL |
| Avaliação direcionada por pares mínimos | Linzen, Dupoux & Goldberg (2016); Marvin & Linzen (2018); Warstadt et al. (2020) |
| Complexidade e comprimento de dependência | Gibson (1998, 2000); Liu (2008); Futrell, Mahowald & Gibson (2015) |
| Representação distribucional e limites do cosseno | Mikolov et al. (2013); Faruqui et al. (2016); Schnabel et al. (2015) |
| Recursos para o português | Nivre et al. (2016) — UD; Rademaker et al. — Bosque; Souza, Nogueira & Lotufo (2020) — BERTimbau |

Fechar o bloco explicitando a lacuna: os trabalhos acima avaliam técnicas
**isoladamente**; não há, para o português, caracterização comparativa sob formalismo
único nem análise dos modos de degeneração.

### 3. Preliminares e notação — ~2 pág · **escrever do zero**

O caderno usa doze notações locais. O artigo precisa de uma.

- Sentença $s$, tokens, forma escrita $w_i$, lema $\ell_i$, etiqueta $p_i$.
- Árvore de dependências $T(s) = (V, A)$, raiz $\rho(s)$, núcleo $h(t)$, função $r$.
- Mapa de traços $\mu_\tau(t)$, com $\bot$ para ausência; $\hat\mu$ para o valor
  **predito** (a distinção $\mu$ vs. $\hat\mu$ é central e deve ser estabelecida aqui).
- Léxico $D$, frequência $f$, corpus de contagens $N$, $V$.
- Convenção: $E_k(s)$ para conjunto de achados da etapa $k$; escore real para medidas
  graduadas.

**Tabela 1 — taxonomia**, que é a contribuição desta seção:

| família | técnicas | veredito | escopo | natureza |
|---|---|---|---|---|
| A · verificação exata | léxico (1), núcleo predicativo (6) | binário exato | local | detector |
| B · verificação aproximada | traços (2), regras (3), verbo mascarado (11) | binário estimado | local | detector |
| C · escore global | SLOR (4), PLL (5) | real | global | ordenador |
| D · escore local | surpresa por token (10) | real | local | ordenador |
| E · descritor | complexidade (7), dependência (8), embeddings (12) | real | global | **não-detector** |

A tese do artigo é, em grande parte, a defesa da última linha.

### 4. Metodologia — ~12 pág · **migração + reorganização**

#### 4.1 Recursos e versões (~1 pág) — **escrever**, consolidando dados dispersos

Tabela única com: mac_morpho (1.012.661 tokens / 53.115 formas), `pt_br_full.txt`
(137.523 formas, $N=424.015.479$), spaCy `pt_core_news_md` 3.8 (UD Bosque v2.8,
`morph_acc` 0,9559, `dep_las` 0,8603, vetores 20.000×300), BERTimbau base cased
(|V| = 29.794), LanguageTool 6.6 (pt: 2.270 regras / 249 grupos).

#### 4.2 Protocolo experimental (~1,5 pág) — **escrever do zero**

- Justificar o desenho de pares mínimos (com a literatura de §2).
- Apresentar a tipologia de perturbações como **tabela**, com o nível linguístico
  afetado em cada uma.
- Declarar o controle negativo (`destruiu`) e sua função.
- Declarar critério de sucesso por técnica: detectar o desvio-alvo **e** não acusar o
  controle.

#### 4.3 a 4.7 As técnicas por família (~9 pág)

Migração das células de fundamento. **Padronizar cada subseção em quatro parágrafos
fixos:** objeto sobre que opera → definição formal → parâmetros e recursos → o que a
técnica devolve. Nada além disso vai para Metodologia.

| subseção | origem no caderno | fórmulas a manter |
|---|---|---|
| 4.3 Verificação exata | cél. 3, 25 | $\mathrm{erro}(w)$, $C_k(w)$, $d_L$ (Damerau), $\mathrm{Pred}(s)$ |
| 4.4 Verificação estrutural | cél. 8 | $T(r)$, $E(s)$ |
| 4.5 Verificação por padrão | cél. 12 | $D_r(s)$, $D(s)$, propriedade de cobertura finita |
| 4.6 Medidas probabilísticas | cél. 16, 20, 41, 45 | SLOR, $P$ interpolada, PLL, $\overline{\mathrm{PLL}}$, surpresa, margem $m(s)$ |
| 4.7 Descritores | cél. 29, 33, 49 | prof, orac, ramif, $d(t)$, $D(s)$, $\bar D$, $X(s)$, cosseno, $\mathbf{v}(s)$ |

**Não migrar para Metodologia:** as subseções "Aplicação das fórmulas aos valores
observados". São resultado, não método — vão para §5 e §6.

### 5. Resultados analíticos — ~4 pág · **reorganização** (conteúdo existe, disperso)

A seção mais original do artigo. Cinco proposições, cada uma com enunciado formal e
demonstração curta. O caderno já contém todas as derivações; falta apenas o formato.

| proposição | enunciado | origem |
|---|---|---|
| **P1** | $\sum_t \lvert\mathrm{filhos}(t)\rvert = n-1 \Rightarrow \mathrm{ramif}(s) = 1 - 1/n$; o índice independe da árvore | cél. 31 |
| **P2** | $c(w_{i-1},w_i)=0 \Rightarrow \mathrm{contrib}_i = \ln(1-\lambda)$; se válido em toda posição, $\mathrm{SLOR}(s)=\ln(1-\lambda)$ | cél. 18 |
| **P3** | sobre $Z=\{i : c(w_{i-1},w_i)=0\}$, $\arg\max \mathrm{surp} = \arg\min c(w_i)$ | cél. 43 |
| **P4** | $\mathbf{v}(\pi(s)) = \mathbf{v}(s)$ para toda permutação $\pi$; logo $\cos = 1$ | cél. 49/51 |
| **P5** | em árvore cujos dependentes pendem todos da raiz, $X(s)=0$ | cél. 35 |

Fechar com **corolário unificador**: P1 e P4 estabelecem que dois dos três descritores
da família E são invariantes à propriedade que dizem mensurar; P2 e P3 estabelecem que
duas das medidas probabilísticas colapsam sob esparsidade. A família E não é detector
por construção, e não por insuficiência de dados.

### 6. Resultados empíricos — ~6 pág · **migração + expansão obrigatória**

#### 6.1 Matriz de cobertura (~1,5 pág)

Generalizar a tabela da célula 14 (hoje 3 técnicas × 4 desvios) para **11 técnicas × 12
tipos de perturbação**. É a figura central do artigo.

#### 6.2 Modos de falha observados (~3 pág)

Migrar, em forma condensada, os achados das subseções de análise:

- normalização do desvio pelo analisador (cél. 10) — com a árvore em `tikz-dependency`
- inalcançabilidade do sintagma pela linguagem de padrões (cél. 14) — com os disparos
- imputação à posição não alterada, no PLL (cél. 23) — com a tabela das 12 parcelas
- pico de surpresa sobre o verbo correto (cél. 43)
- proximidade de antônimos superior à de sinônimos (cél. 51)
- projetividade forçada pelo analisador (cél. 35)

#### 6.3 Desempenho quantitativo — **a expansão que falta** (~1,5 pág)

Esta é a única lacuna que impede submissão a revista indexada.

**O que fazer:** extrair $N$ sentenças de referência da própria base de eventos de fogo
($N = 30$ a $50$) e aplicar a cada uma as 12 perturbações do protocolo, gerando
$N \times 13$ itens (com o controle). Anotar o desvio-alvo de cada item.

**O que passa a ser reportável:** precisão, revocação e $F_1$ por técnica e por tipo de
desvio; taxa de falso positivo sobre os controles; e — decisivo para a tese — a
demonstração de que os descritores da família E não separam as classes, com intervalo
de confiança.

**Custo estimado:** a geração das perturbações é automatizável a partir do protocolo já
definido; a anotação é de baixa ambiguidade (o desvio é introduzido, não descoberto).
Ordem de 1 a 2 dias de trabalho.

> Sem esta expansão o artigo permanece válido como **caracterização formal** (§5 sustenta
> sozinho), mas não pode afirmar desempenho comparativo. Neste caso, reescrever §6.3
> como declaração explícita de limitação e mover as afirmações quantitativas para o
> condicional.

### 7. A pipeline — ~4 pág · **migração** (cél. 37 e 39)

- **7.1 Critério de seleção** — derivar a exclusão de SLOR, surpresa e embeddings
  diretamente de P2, P3 e P4. Este é o ponto em que §5 paga: a seleção não é preferência
  de projeto, é consequência das proposições.
- **7.2 Arquitetura** — quatro etapas, com o diagrama de fluxo em TikZ (hoje inexistente;
  vale a pena criar).
- **7.3 Os três ajustes** — verbo finito na raiz, gênero no particípio passivo, numeral
  por valor.
- **7.4 Veredito por vacuidade** — $\mathrm{Loc}(s) \neq \varnothing \Rightarrow$
  reprovação; o único limiar ($\theta$ da etapa semântica) decide admissão de achado, não
  o veredito.
- **7.5 Propagação de erro entre etapas** — a marcação `[árvore sob suspeita]` e sua
  justificativa.
- **7.6 Cobertura e limites** — escolha lexical e erro factual.

### 8. Discussão — ~2 pág · **reorganização** (das 24 subseções "Quando usar/não usar")

As 24 subseções de orientação prática somam ~5 páginas. Condensar em:

- **Tabela 8.1 — Diretrizes de emprego**, com uma linha por técnica e três colunas:
  condição de aplicabilidade, condição de inaplicabilidade, sintoma observável de
  degeneração. Isso comprime 5 páginas em 1.
- **8.2 Ameaças à validade** — escrever do zero: dependência de uma única sentença de
  referência (ou do corpus expandido); dependência do analisador; corpus de contagens de
  1994 fora do domínio; sensibilidade a caixa no BERTimbau.
- **8.3 Generalização** — o que transfere para outras línguas e outros domínios.

### 9. Conclusão — ~1 pág · **escrever do zero**

Retomar as contribuições; enunciar o trabalho futuro (vetores contextuais em lugar de
estáticos; verificação factual contra a base; ampliação da gramática de padrões).

### Apêndices

- **A** — código das técnicas (as 14 células), em `listings`.
- **B** — tabelas completas de derivação (unigrama, bigrama, 12 parcelas do PLL), que no
  corpo aparecem abreviadas.
- **C** — protocolo de perturbação e o corpus expandido.

---

## 5. Mapa de migração célula → seção

| célula | destino | ação |
|---|---|---|
| 0 | §1 (organização) | reescrever como parágrafo corrido |
| 3, 25 | §4.3 | migrar; unificar notação |
| 8 | §4.4 | migrar |
| 12 | §4.5 | migrar |
| 16, 20, 41, 45 | §4.6 | migrar; unificar notação de $\ln P$ |
| 29, 33, 49 | §4.7 | migrar |
| 5, 6 | §6.1, §6.2 | condensar 60 % |
| 10 | §6.2 | condensar; árvore → `tikz-dependency` |
| 14 | §6.1, §6.2 | a tabela T1×T2×T3 vira a matriz de cobertura |
| 18 | §5 (P2), §6.2, Ap. B | dividir |
| 23 | §6.2, Ap. B | condensar 50 % |
| 27 | §4.3, §6.2 | dividir |
| 31 | §5 (P1), §6.2 | dividir |
| 35 | §5 (P5), §6.2 | dividir |
| 37, 39 | §7 | migrar quase integralmente |
| 43 | §5 (P3), §6.2 | dividir |
| 47 | §6.2, §8.2 | dividir; a tabela de caixa vai para ameaças |
| 51 | §5 (P4), §6.2 | dividir |
| 24 blocos "Quando usar/não usar" | §8.1 | **condensar em uma tabela** |
| 14 células de código | Ap. A | migrar |

**Compressão resultante:** 40 pág → ~26 pág de corpo + 6 de apêndice.

---

## 6. Infraestrutura LaTeX

### Preâmbulo mínimo

```latex
\documentclass[11pt,a4paper]{article}   % ou sbc-template / elsarticle
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[brazil]{babel}
\usepackage{amsmath,amssymb,amsthm}
\usepackage{booktabs,multirow,array}
\usepackage{graphicx,xcolor}
\usepackage{tikz,tikz-dependency}
\usepackage{listings}
\usepackage[hidelinks]{hyperref}
\usepackage[style=abnt]{biblatex}       % ou o estilo do veículo
\addbibresource{referencias.bib}

\theoremstyle{plain}
\newtheorem{proposicao}{Proposição}
\newtheorem{corolario}[proposicao]{Corolário}
\theoremstyle{definition}
\newtheorem{definicao}{Definição}
```

### Ambientes de teorema — essenciais

§5 depende deles. As cinco proposições ficam em `\begin{proposicao}` com
`\begin{proof}`. Sem esses ambientes, o resultado mais forte do artigo se dissolve em
prosa.

### Árvores de dependência

O caderno representa as árvores em ASCII. **Não migrar ASCII para o artigo.** Converter
para `tikz-dependency`:

```latex
\begin{dependency}[theme=simple]
  \begin{deptext}[column sep=0.8cm]
    Há \& três \& dias \& o \& incêndio \& atingiu \& uma \& área \\
  \end{deptext}
  \depedge{6}{3}{obl}
  \depedge{6}{5}{nsubj}
  \depedge{5}{4}{det}
  \deproot{6}{ROOT}
\end{dependency}
```

São necessárias ~6 figuras: par oração/fragmento (§6.2), árvore deformada pela grafia
(§7.5), árvore da passiva com extraposição (§6.2), e os dois pares de comprimento de
dependência (§4.7).

### Diagrama da pipeline

Não existe no caderno e vale criar: quatro caixas em sequência, com a marcação de
suspeita como aresta lateral e o $\theta$ destacado como único parâmetro.

### Tabelas

As 316 linhas de tabela em Markdown viram `booktabs`. Regra: `\toprule`, `\midrule`,
`\bottomrule`; sem linhas verticais. As três tabelas longas (unigrama, bigrama, 12
parcelas) vão para o apêndice em `longtable`, com versão abreviada no corpo.

### Código

`listings` com estilo sóbrio, ou `minted` se houver Pygments disponível. Todo o código
no Apêndice A; no corpo, no máximo trechos de 3–4 linhas.

### Notação — decisão a fixar antes de escrever

O caderno alterna `$1{.}012{.}661$` (matemático) e `1.012.661` (texto). Em LaTeX com
`babel-brazil`, usar `siunitx` com `\num{1012661}` resolve de uma vez e garante
consistência. Fixar isso no início evita retrabalho.

---

## 7. Ordem de execução recomendada

1. **Decidir veículo** — determina extensão e estilo de citação.
2. **Escrever §3 (preliminares e notação)** — tudo o mais depende da notação unificada.
3. **Escrever §5 (proposições)** — é o núcleo; se as demonstrações não fecharem em
   formato de teorema, a estrutura muda.
4. **Expandir o corpus (§6.3)** — em paralelo com 2 e 3, por ser trabalho independente.
5. **Migrar §4** — mecânico, uma vez fixada a notação.
6. **Migrar §§6–7** — depende de 3, 4 e 5.
7. **Escrever §§1, 2, 8, 9** — introdução e trabalhos relacionados por último, quando o
   conteúdo já está estabilizado.
8. **Converter figuras e tabelas.**

---

## 8. Riscos

| risco | mitigação |
|---|---|
| Revisor exige avaliação quantitativa | executar §6.3 antes da submissão |
| Revisor questiona corpus de contagens de 1994 fora do domínio | já é achado do artigo (§6.2); declarar em §8.2 como escolha deliberada de demonstração |
| §4 fica desproporcional (11 técnicas) | disciplina dos quatro parágrafos fixos por técnica; excedente vai para apêndice |
| As proposições parecerem triviais | apresentá-las junto com a evidência de que a técnica é usada como detector na prática; a trivialidade da demonstração é o argumento, não uma fraqueza |
| Tradução para inglês | decidir antes de escrever; retraduzir 26 páginas é caro |
