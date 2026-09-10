# Questões 3, 4 e 5 — Estado e recursos

## Questão 3 — Estado

### Comando

```bash
ps -o pid,stat,cmd -p 21387
```

### Evidência

```text
PID    STAT CMD
21387  Ss   bash
```

### Interpretação

O estado `S` indica que o processo está em estado de espera/sleeping.

A letra `s` indica que o processo é um líder de sessão.

---

## Questão 4 — CPU e memória

### Primeiro momento

```bash
ps -o pid,%cpu,%mem,cmd -p 21387
```

```text
PID    %CPU %MEM CMD
21387  0.0  0.3 bash
```

### Segundo momento

```bash
ps -o pid,%cpu,%mem,cmd -p 21387
```

```text
PID    %CPU %MEM CMD
21387  0.0  0.3 bash
```

### Interpretação

Nos dois momentos, o processo apresentou utilização de `0.0%` de CPU e `0.3%` de memória.

Isso indica que o `bash` estava praticamente ocioso durante a medição.

---

## Questão 5 — Prioridade e nice

### Estado inicial

```bash
ps -o pid,ni,pri,cmd -p 21387
```

```text
PID    NI PRI CMD
21387   0  19 bash
```

### Alteração

```bash
renice -n 5 -p 21387
```

Resultado:

```text
21387 (process ID) old priority 0, new priority 5
```

### Estado após a alteração

```bash
ps -o pid,ni,pri,cmd -p 21387
```

```text
PID    NI PRI CMD
21387   5  14 bash
```

### Interpretação

O valor nice foi alterado de `0` para `5`.

Um valor nice maior significa que o processo recebe menor preferência relativa de CPU em relação a processos com nice menor.

O valor `PRI` exibido pelo `ps` também mudou de `19` para `14`.
