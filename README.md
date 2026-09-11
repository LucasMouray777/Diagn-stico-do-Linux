Trabalho 1 — Diagnóstico de Processos em Linux

- Disciplina: Sistemas Operacionais — ADS 
- Faculdade: Serra Dourada 
- Professor: Guibson Krause 
- Aluno(s): Lucas Moura e Davi Mota
- Processo analisado: Firefox (navegador) 

### 1. Descrição da aplicação e justificativa ###

O processo escolhido foi o Firefox (instalado via Snap), um navegador de código aberto amplamente usado. A escolha se justifica porque:

É um processo de usuário seguro para manipular (não é serviço crítico do sistema);
Pode ser interrompido, retomado e encerrado sem afetar o SO;
Apresenta uma estrutura rica para o diagnóstico: múltiplos processos filhos (multiprocesso) e múltiplas threads por processo, permitindo observar bem os conceitos de hierarquia, threads e /proc.

### 2. Ambiente utilizado ###

Item	Detalhe
Distribuição	Ubuntu
Máquina	VM (VirtualBox) — usuário vboxuser
Instalação do Firefox	Pacote Snap (/snap/firefox/6966/...)

### 3. Como executar a aplicação analisada ###

bash
firefox &

O Firefox foi iniciado normalmente pela interface gráfica. Após a inicialização, o processo pai original (que o lançou) termina, e o Firefox é "adotado" pelo init/systemd (PID 1) — por isso o PPID observado é 1.

### 4. Comandos utilizados ###

Lista completa e comentada em comandos/comandos-utilizados.md.

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

### 5. Evidências e interpretação por requisito ###
   
5.1 PID e PPID

Diretório: evidencias/01-pid-ppid/

PID: 24287   PPID: 1

Interpretação: o PID identifica unicamente o processo; o PPID 1 mostra que, após o reparenting automático do kernel (quando o processo lançador original termina), o Firefox passa a ser filho do init/systemd.

5.2 Árvore de processos

Diretório: evidencias/02-arvore-processos/

O Firefox usa arquitetura multiprocesso: o processo principal cria, via forkserver, filhos especializados — RDD Process (mídia), Socket Process (rede), Utility Process, vários Web Content (isolamento por aba/site) e WebExtensions — cada um com suas próprias threads.

Interpretação: esse modelo pai → filho via fork()/exec() isola falhas: se uma aba travar, apenas o Web Content daquela aba é afetado, não o navegador inteiro.

5.3 Estado do processo

Diretório: evidencias/03-estado-recursos/

Momento	STAT	Significado
Repouso	Sl	S = sleeping; l = multithreaded
Após SIGSTOP	Tl	T = stopped
Após SIGCONT	Sl	Retomado

Interpretação: S é o estado normal de um processo interativo — a maior parte do tempo é gasta esperando eventos (I/O, rede, entrada do usuário), sem consumir CPU ativamente.

5.4 CPU e memória

Diretório: evidencias/03-estado-recursos/

Momento	%CPU	%MEM	VmRSS
Repouso	0.3%	16.9%	341.440 kB (~333 MB)

Interpretação: em repouso, o Firefox já reserva bastante memória (cache, motor JS, processos de renderização ativos), mas consome pouca CPU.

5.5 Prioridade e nice

Diretório: evidencias/03-estado-recursos/

	PRI	NI
Antes	19	0
Depois de renice 5 -p 24287	14	5

Interpretação: o nice (NI) vai de -20 a 19 e é o ajuste que o usuário pede ao kernel para a prioridade de escalonamento. Aumentar para 5 pede menos prioridade de CPU. O PRI caiu de 19 para 14 porque já reflete a prioridade dinâmica calculada pelo escalonador CFS.

5.6 Threads

Diretório: evidencias/04-threads/

Threads: 69

Interpretação: o Firefox é fortemente multithreaded — 69 threads só no processo principal, cada uma especializada (renderização, áudio, SQLite, DNS...). Threads de um mesmo processo compartilham memória e descritores de arquivo, diferente de processos separados.

5.7 /proc/PID

Diretório: evidencias/05-proc/

Arquivo	O que mostra
status	Resumo legível: estado, PPid, memória, nº de threads
stat	Dados "crus" usados pelo kernel/ps/top
limits	Limites de recursos (arquivos abertos, processos, pilha)
5.8 Sinais: SIGSTOP, SIGCONT, SIGTERM

Diretório: evidencias/06-sinais/

Sinal	Efeito observado
SIGSTOP	STAT Sl → Tl (processo suspenso, continua na memória)
SIGCONT	STAT Tl → Sl (retomado de onde parou)
SIGTERM	Processo removido da tabela de processos (ps -p sem saída)

Interpretação: SIGSTOP/SIGCONT controlam execução sem destruir o processo; SIGTERM pede encerramento (e pode ser tratado pelo processo antes de sair), diferente do SIGKILL, que mata incondicionalmente.

### 6. Conclusão ####

O experimento com o Firefox permitiu observar na prática: a relação pai-filho via reparenting, a arquitetura multiprocesso/multithread para isolamento e desempenho, os estados de processo e suas transições por sinais de controle de job, o papel do nice/renice no escalonamento, e a diferença entre suspender e encerrar um processo. A interface /proc se mostrou uma fonte rica de introspecção do kernel, acessível sem ferramentas adicionais.
