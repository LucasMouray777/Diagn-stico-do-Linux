# Evidência — PID e PPID

```bash
pgrep -a firefox
```
```
24287 /snap/firefox/6966/usr/lib/firefox/firefox
```

```bash
ps -o pid,ppid,stat,pri,ni,%cpu,%mem,cmd -p 24287
```
```
  PID    PPID STAT PRI  NI %CPU %MEM CMD
24287       1 Sl    19   0  0.3 16.9 /snap/firefox/6966/usr/lib/firefox/firefox
```

## Interpretação

O PID `24287` identifica unicamente o processo do Firefox no sistema. O PPID `1` indica que o
processo pai é o `init`/`systemd`: ao ser iniciado pela interface gráfica, o processo lançador
original termina logo após criar o Firefox, e o kernel reatribui o PPID do processo órfão para o
PID 1 (reparenting), que passa a ser responsável por "colher" o processo quando ele terminar.
