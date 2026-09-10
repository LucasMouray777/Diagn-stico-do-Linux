# Questão 1 — PID e PPID

## Comando

```bash
ps -o pid,ppid,cmd
```

## Evidência

```text
PID    PPID CMD
21387  21381 bash
21396  21387 ps -o pid,ppid,cmd
```

## Interpretação

O comando `ps` mostra os processos em execução juntamente com seus identificadores.

O processo `bash` possui PID `21387` e PPID `21381`. Isso significa que o processo `21381` é o processo pai do `bash`.

O próprio comando `ps` possui PID `21396` e PPID `21387`, mostrando que ele foi executado pelo `bash`.
