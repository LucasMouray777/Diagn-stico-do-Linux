# Questão 7 — Informações do processo através do `/proc`

## Comandos

```bash
cat /proc/21387/status
cat /proc/21387/stat
cat /proc/21387/cmdline
cat /proc/21387/limits
```

## `/proc/21387/status`

O arquivo apresenta diversas informações sobre o processo.

Principais dados observados:

```text
Name:   bash
State:  S (sleeping)
Pid:    21387
PPid:   21381
Uid:    1000
Gid:    1000
Threads: 1
VmRSS:  6160 kB
```

O processo analisado é o `bash`, com PID `21387`. O estado `S` indica que está dormindo/aguardando. O processo possui uma thread e apresenta `6160 kB` de memória residente.

## `/proc/21387/stat`

Esse arquivo contém informações numéricas detalhadas sobre o processo, incluindo PID, estado, processo pai, prioridades, utilização de CPU e outras informações internas do kernel.

## `/proc/21387/cmdline`

Resultado:

```text
bash
```

O resultado confirma que o comando associado ao processo é `bash`.

## `/proc/21387/limits`

Esse arquivo apresenta os limites de recursos disponíveis para o processo.

Entre os limites observados estão:

* tempo máximo de CPU;
* tamanho máximo de arquivos;
* tamanho da pilha;
* quantidade máxima de processos;
* quantidade máxima de arquivos abertos;
* memória bloqueada;
* sinais pendentes.

## Interpretação

A interface `/proc` permite consultar informações internas dos processos diretamente pelo sistema de arquivos virtual do Linux.

A consulta aos arquivos `status`, `stat`, `cmdline` e `limits` fornece diferentes aspectos do processo `21387`.

## Conclusão

Foi possível analisar detalhadamente o processo `bash` utilizando a interface `/proc`, sem depender somente do comando `ps`.
