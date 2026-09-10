#!/bin/bash
# Questão 5 - Exibir e alterar a prioridade (nice/pri) do processo bash
# Substitua 21387 pelo PID atual do seu bash (verifique com: echo $$)

ps -o pid,ni,pri,cmd -p 21387

renice -n 5 -p 21387

ps -o pid,ni,pri,cmd -p 21387
