Diagnóstico do Linux

Trabalho 1 — Diagnóstico de Processos em Linux

Disciplina: Sistemas Operacionais — ADS 
Aluno(s): Lucas Moura e Davi Mota
Processo analisado: Firefox (navegador)

1. Descrição da aplicação e justificativa

O processo escolhido foi o Firefox (instalado via Snap), um navegador de código aberto muito utilizado. A escolha foi feita porque é um processo de usuário que pode ser interrompido, retomado ou encerrado sem impactar o sistema operacional. Ele também tem uma estrutura interessante para análise: possui vários processos filhos (multiprocesso) e múltiplas threads por processo, o que ajuda a entender conceitos como hierarquia, threads e o diretório /proc.

2. Ambiente utilizado

Distribuição: Ubuntu (xunbutu4)

Tipo de máquina: VM (VirtualBox — usuário vboxuser)

Instalação do Firefox: pacote Snap (/snap/firefox/6966/...)

3. Como executar a aplicação analisada

bash

firefox &

O Firefox foi iniciado normalmente pela interface gráfica (ícone do sistema), o que faz com que, após a inicialização, o processo pai original (o processo que o lançou) termine e o Firefox seja “adotado” pelo processo init/systemd (PID 1) — por isso o PPID observado é 1.

4. Comandos utilizados (na ordem do experimento)

Ver detalhamento completo em comandos/comandos-utilizados.md.

bash

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

5. Evidências e interpretação por requisito

5.1 PID e PPID (evidencias/01-pid-ppid/)

pgrep -a firefox

24287 /snap/firefox/6966/usr/lib/firefox/firefox

ps -o pid,ppid,stat,pri,ni,%cpu,%mem,cmd -p 24287

24287       1 Sl   19   0  0.3 16.9 /snap/firefox/6966/usr/lib/firefox/firefox

Interpretação: O PID (Process ID) 24287 identifica unicamente o processo do Firefox no sistema. O PPID (Parent Process ID) é 1, ou seja, o processo pai é o init/systemd. Isso acontece porque, ao iniciar o Firefox pela interface gráfica, o processo que o lançou termina logo após a criação do Firefox, e o kernel encarrega o processo de PID 1 de cuidar dele — esse é o mecanismo de “reparenting", que ajuda a monitorar o processo quando ele termina.

5.2 Árvore de processos (evidencias/02-arvore-processos/)

firefox(24287)─┬─forkserver(24388)─┬─Privileged Cont(24420)─┬─{Privileged Cont}(24424)

│                   ├─RDD Process(24428)

│                   ├─Socket Process(24391)

│                   ├─Utility Process(24563)

│                   ├─Web Content(24570)

│                   ├─Web Content(24576)

│                   ├─Web Content(24613)

│                   └─WebExtensions(24506)

├─{firefox}(24328) ... (dezenas de threads do processo principal)

Interpretação: O Firefox usa uma arquitetura multiprocesso: o processo principal (24287) cria processos filhos especializados — como RDD Process (decodificação de mídia), Socket Process (rede), Utility Process, Web Content (um por grupo de abas) e WebExtensions (extensões). Cada um desses filhos tem várias threads, mostradas entre chaves pelo pstree. Essa estrutura reflete como os processos são criados com fork() e exec(), ajudando a isolar falhas e melhorar segurança e desempenho.

5.3 Estado do processo (evidencias/03-estado-recursos/)

Momento	STAT	Significado

Em repouso	Sl	S = sleeping (dormindo, esperando evento como I/O); l = multithreaded

Após kill -STOP	Tl	T = stopped (parado por sinal de controle de job); ainda multithread

Após kill -CONT	Sl	Retornou ao estado de espera normal

Interpretação: O estado S é comum para processos interativos como o navegador: ele fica dormindo na maior parte do tempo, esperando eventos como entrada do usuário ou rede. O estado T ocorre quando enviamos o sinal SIGSTOP, que pausa o processo até receber SIGCONT. O processo continua na memória, mas não roda mais até ser retomado.

5.4 CPU e memória (evidencias/03-estado-recursos/)

Momento 1 (repouso):

%CPU 0.3   %MEM 16.9   VmRSS: 341440 kB (~333 MB)

Momento 2 (sob carga): [PREENCHER — abrir várias abas, tocar um vídeo, e capturar novamente ps -o pid,%cpu,%mem,rss -p 24287 para comparação]

Interpretação: Em repouso, o Firefox consome pouca CPU (0,3%) mas muita memória (~333 MB), como é comum em navegadores que mantêm cache e processos de renderização ativos. Uma segunda medição sob carga é necessária para mostrar como o consumo de CPU aumenta com atividade, como rolagem de página ou vídeo.

5.5 Prioridade e nice (evidencias/03-estado-recursos/)

Antes:  PRI 19   NI 0

renice 5 -p 24287

24287 (process ID) old priority 0, new priority 5

Depois: PRI 14   NI 5

Interpretação: O valor nice varia de -20 (maior prioridade) a 19 (menor prioridade). Aumentar o nice de 0 para 5 quer dizer que o processo terá menos prioridade de CPU. O campo PRI do ps diminui de 19 para 14, o que é esperado, pois reflete a prioridade efetiva do escalonador. O importante é que o nice maior significa que o processo cede mais o processador para outros.

5.6 Threads (evidencias/04-threads/)

ps -L -p 24287

PID     LWP  TTY  TIME  CMD

24287  24378  ?  00:00:00  Worker Launcher

24287  24379  ?  00:00:01  Softwar~cThread

24287  24380  ?  00:00:00  Renderer

24287  24381  ?  00:00:00  WRWorker#0

...

Threads: 69   (confirmado em /proc/24287/status)

Interpretação: O Firefox é muito multithreaded: o processo principal tem 69 threads, cada uma com uma tarefa específica (renderização, áudio, banco de dados, DNS, etc.). As threads compartilham memória e arquivos, o que torna a comunicação mais rápida, mas exige cuidado com sincronização para evitar problemas.

5.7 /proc/PID (evidencias/05-proc/)

Fontes exploradas:

/proc/24287/status — resumo legível do estado do processo: nome, estado (S), PPid (1), UID/GID, uso de memória detalhado (VmRSS: 341440 kB), número de threads (69), máscara de sinais bloqueados/ignorados (SigBlk, SigIgn).

/proc/24287/stat — versão “crua” usada pelo kernel/ferramentas como ps e top para extrair estado, tempos de CPU em modo usuário/kernel e prioridade — é a fonte primária de onde ps deriva boa parte dos campos exibidos.

/proc/24287/limits — limites de recursos aplicados ao processo: máximo de arquivos abertos, máximo de processos, tamanho de pilha, entre outros — útil para diagnosticar erros como “too many open files".

[PREENCHER — 4ª fonte, ex: /proc/24287/cmdline ou /proc/24287/fd]

bash

cat /proc/24287/cmdline | tr '\0'' '

Mostra a linha de comando exata usada para iniciar o processo (útil para confirmar com quais argumentos a aplicação foi executada).

5.8 Sinais: SIGSTOP, SIGCONT, SIGTERM (evidencias/06-sinais/)

kill -STOP 24287

ps → STAT: Tl   (processo suspenso)

kill -CONT 24287

ps → STAT: Sl   (processo retomado, volta a dormir/aguardar)

kill -TERM 24287

ps -p 24287 → (sem saída — processo encerrado)

Interpretação:

SIGSTOP suspende a execução do processo imediatamente, sem que ele possa interceptar ou ignorar o sinal. O processo continua na memória, mas não roda até receber SIGCONT.

SIGCONT retoma a execução exatamente de onde parou, devolvendo o processo ao escalonador.

SIGTERM é um sinal de encerramento que o processo pode capturar para fazer limpeza antes de sair — diferente de SIGKILL, que mata o processo sem opção de tratamento. Após o SIGTERM, o processo é removido da tabela do kernel.

A diferença entre pausar (SIGSTOP) e terminar (SIGTERM) é que pausar mantém o processo vivo na memória, enquanto terminar libera os recursos e remove o processo da tabela do kernel.

6. Interpretação técnica geral / Conclusão

O experimento com o Firefox permitiu observar de forma prática vários conceitos centrais de Sistemas Operacionais: a relação de hierarquia pai-filho (o Firefox sendo adotado pelo PID 1 após reparenting), a arquitetura multiprocesso e multithread usada para isolamento e desempenho, o significado prático dos estados de processo (S, T) e suas transições provocadas por sinais de controle de job, o papel do nice/renice no ajuste da prioridade de escalonamento sem controle direto do usuário sobre o algoritmo do escalonador, e a diferença semântica entre suspender e encerrar um processo. A interface /proc se mostrou uma fonte rica e acessível de introspecção do kernel sobre processos em execução, permitindo diagnósticos sem ferramentas adicionais. A comparação de CPU e memória em carga mostrou que o Firefox consome recursos significativos, especialmente quando abertas várias guias, o que pode afetar o desempenho geral do sistema. Houve também algumas anomalias, como a dificuldade em identificar corretamente os processos filhos em alguns casos, o que pode ser um limite da interface /proc. Além disso, a prioridade de escalonamento ajustada pelo nice não teve um impacto muito visível durante o teste, o que pode indicar que o algoritmo do escalonador é mais complexo do que se esperava.
