# Questão 2 — Árvore de processos

## Comando

```bash
pstree -p 21387
```

## Evidência

```text
bash(21387)───pstree(21419)
```

## Interpretação

O comando `pstree` apresenta a relação hierárquica entre os processos.

O processo `bash`, de PID `21387`, aparece como processo pai do `pstree`, de PID `21419`.

Isso demonstra visualmente a relação pai-filho entre os processos.
