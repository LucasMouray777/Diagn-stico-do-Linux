# Comandos utilizados

## Questão 1

```bash
ps -o pid,ppid,cmd
```

## Questão 2

```bash
pstree -p 21387
```

## Questão 3

```bash
ps -o pid,stat,cmd -p 21387
```

## Questão 4

```bash
ps -o pid,%cpu,%mem,cmd -p 21387
```

```bash
ps -o pid,%cpu,%mem,cmd -p 21387
```

## Questão 5

```bash
ps -o pid,ni,pri,cmd -p 21387
```

```bash
renice -n 5 -p 21387
```

```bash
ps -o pid,ni,pri,cmd -p 21387
```

## Questão 6

```bash
ps -o pid,tid,cmd -p 21387
```

## Questão 7

```bash
cat /proc/21387/status
```

```bash
cat /proc/21387/stat
```

```bash
cat /proc/21387/cmdline
```

```bash
cat /proc/21387/limits
```

## Questão 8

```bash
sleep 300 &
```

```bash
ps -o pid,stat,cmd -p 21578
```

```bash
kill -19 21578
```

```bash
ps -o pid,stat,cmd -p 21578
```

```bash
kill -18 21578
```

```bash
ps -o pid,stat,cmd -p 21578
```

```bash
kill -15 21578
```
