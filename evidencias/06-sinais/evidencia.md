# Questão 8 — Sinais de processos

## 1. Criação do processo

```bash
sleep 300 &
```

Resultado:

```text
[1] 21578
```

O processo `sleep` recebeu o PID `21578`.

## 2. Estado inicial

```bash
ps -o pid,stat,cmd -p 21578
```

Resultado:

```text
PID    STAT CMD
21578  SN   sleep 300
```

O processo estava em execução/espera normal.

## 3. SIGSTOP

```bash
kill -19 21578
```

Resultado:

```text
[1]+  Stopped  sleep 300
```

Depois:

```bash
ps -o pid,stat,cmd -p 21578
```

```text
PID    STAT CMD
21578  TN   sleep 300
```

O estado `T` indica que o processo foi interrompido.

## 4. SIGCONT

```bash
kill -18 21578
```

Depois:

```bash
ps -o pid,stat,cmd -p 21578
```

Resultado:

```text
PID    STAT CMD
21578  SN   sleep 300
```

O processo voltou a executar.

## 5. SIGTERM

```bash
kill -15 21578
```

Resultado:

```text
bash: kill: (21578) No such process
[1]+  Done                    sleep 300
```

O processo foi encerrado. A mensagem indica que o PID não existia mais quando o shell tentou executar a operação, pois o `sleep` já havia terminado.

## Interpretação

Os sinais utilizados foram:

| Sinal   | Número | Função                              |
| ------- | -----: | ----------------------------------- |
| SIGSTOP |     19 | Interrompe o processo               |
| SIGCONT |     18 | Continua um processo interrompido   |
| SIGTERM |     15 | Solicita o encerramento do processo |

## Conclusão

A experiência demonstrou na prática como os sinais podem controlar o estado de um processo no Linux: primeiro o processo foi interrompido, depois retomado e finalmente encerrado.
