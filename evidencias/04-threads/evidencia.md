# Questão 6 — Threads

## Comando

```bash
ps -o pid,tid,cmd -p 21387
```

## Evidência

```text
PID     TID CMD
21387   21387 bash
```

## Interpretação

O processo possui PID `21387` e sua thread possui TID `21387`.

Como foi apresentada apenas uma thread, o processo `bash` analisado possui uma única thread nesse momento.
