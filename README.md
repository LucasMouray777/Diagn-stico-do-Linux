Trabalho 1 — Diagnóstico do Linux

- Disciplina: Sistemas Operacionais — ADS

- Faculdade: Serra Dourada

- Professor: Guibson Krause

- Aluno(s): Lucas Moura e Davi Mota

- Processo analisado: Firefox (navegador)

### 1. Descrição da aplicação e justificativa ###

O processo escolhido foi Firefox, instalado via Snap. Firefox é um navegador de código aberto que a maioria das pessoas usa. A escolha se justifica porque:

- Firefox é um processo de usuário que pode ser manipulado com segurança; ele não é um serviço crítico do sistema.

- Firefox pode ser interrompido, retomado e encerrado sem causar dano ao sistema operacional.

- Firefox tem uma estrutura rica para o diagnóstico: ele cria vários processos filhos (modelo multiprocesso) e cada processo tem várias threads. Isso permite observar bem os conceitos de hierarquia, threads e /proc.

### 2. Ambiente utilizado ###

| Item | Detalhe |

|------|---------|

| Distribuição | Ubuntu |

| Máquina | VM (VirtualBox) — usuário vboxuser |

| Instalação do Firefox | Pacote Snap (/snap/firefox/6966/...) |

### 3. Como executar a aplicação analisada ###

```bash

firefox &

```

Firefox foi iniciado normalmente pela interface gráfica. Quando o processo inicial termina, o Firefox é “adotado” pelo init/systemd (PID 1). Por isso o PPID observado é 1.

### 4. Comandos utilizados ###

Lista completa e comentada em comandos/comandos-utilizados.md.

```bash

pgrep -a firefox

ps -o pid,ppid,stat,pri,ni,%cpu,%mem,cmd -p 24287

pstree -p 24287

ps -L -p 24287

cat /proc/24287/status

cat /proc/24287/stat

cat /proc/24287/limits

kill -STOP 24287

kill -CONT 24287

renice 5 -p 24287

kill -TERM 24287

ps -p 24287

```

### 5. Evidências e interpretação por requisito ###

5.1 PID e PPID

Diretório: evidencias/01-pid-ppid/

```

PID: 24287   PPID: 1

```

Interpretação: o PID identifica unicamente o processo. O PPID 1 mostra que, depois do reparenting automático do kernel, Firefox passa a ser filho do init/systemd.

5.2 Árvore de processos

Diretório: evidencias/02-arvore-processos/

Firefox usa arquitetura multiprocesso: o processo principal cria, via forkserver, filhos especializados — RDD Process (mídia), Socket Process (rede), Utility Process, vários Web Content (isolamento por aba/site) e WebExtensions. Cada um tem suas próprias threads.

Interpretação: esse modelo pai → filho via fork()/exec() isola falhas. Se uma aba travar, apenas o Web Content daquela aba é afetado, não o navegador inteiro.

5.3 Estado do processo

Diretório: evidencias/03-estado-recursos/

| Momento | STAT | Significado |

|---------|------|-------------|

| Repouso | Sl | S = sleeping; l = multithreaded |

| Após SIGSTOP | Tl | T = stopped |

| Após SIGCONT | Sl | Retomado |

Interpretação: S é o estado normal de um processo interativo. A maior parte do tempo o processo fica esperando eventos (I/O, rede, entrada do usuário) e não consome CPU ativamente.

5.4 CPU e memória

Diretório: evidencias/03-estado-recursos/

| Momento | %CPU | %MEM | VmRSS |

|---------|------|------|-------|

| Repouso | 0.3% | 16.9% | 341.440 kB (~333 MB) |

Interpretação: em repouso, Firefox já reserva bastante memória (cache, motor JS, processos de renderização ativos), mas consome pouca CPU.

5.5 Prioridade e nice

Diretório: evidencias/03-estado-recursos/

```

PRI  NI

Antes   19   0

Depois  14   5

```

Interpretação: nice (NI) varia de -20 a 19 e indica a prioridade de escalonamento solicitada pelo usuário. Aumentar para 5 pede menos prioridade de CPU. O PRI caiu de 19 para 14 porque já reflete a prioridade dinâmica calculada pelo escalonador CFS.

5.6 Threads

Diretório: evidencias/04-threads/

```

Threads: 69

```

Interpretação: Firefox é fortemente multithreaded — 69 threads apenas no processo principal. Cada thread tem uma função específica (renderização, áudio, SQLite, DNS...). Threads de um mesmo processo compartilham memória e descritores de arquivo, diferente de processos separados.

5.7 /proc/PID

Diretório: evidencias/05-proc/

| Arquivo | O que mostra |

|---------|--------------|

| status | Resumo legível: estado, PPid, memória, nº de threads |

| stat | Dados “crus” usados pelo kernel/ps/top |

| limits | Limites de recursos (arquivos abertos, processos, pilha) |

5.8 Sinais: SIGSTOP, SIGCONT, SIGTERM

Diretório: evidencias/06-sinais/

| Sinal | Efeito observado |

|-------|------------------|

| SIGSTOP | STAT Sl → Tl (processo suspenso, continua na memória) |

| SIGCONT | STAT Tl → Sl (retomado de onde parou) |

| SIGTERM | Processo removido da tabela de processos (ps -p sem saída) |

Interpretação: SIGSTOP/SIGCONT controlam a execução sem destruir o processo. SIGTERM pede encerramento, diferente do SIGKILL, que mata o processo incondicionalmente.

### 6. Conclusão ####

O experimento com Firefox permitiu observar na prática: a relação pai-filho via reparenting, a arquitetura multiprocesso/multithread para isolamento e desempenho, os estados de processo e suas transições por sinais de controle de job, o papel do nice/renice no escalonamento, e a diferença entre suspender e encerrar um processo. A interface /proc se mostrou uma fonte rica de introspecção do kernel, acessível sem ferramentas adicionais.
