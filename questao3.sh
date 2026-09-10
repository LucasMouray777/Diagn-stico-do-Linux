#!/bin/bash
# Questão 3 - Exibir o status (STAT) do processo bash
# Substitua 21387 pelo PID atual do seu bash (verifique com: echo $$)
ps -o pid,stat,cmd -p 21387
