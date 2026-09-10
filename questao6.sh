#!/bin/bash
# Questão 6 - Exibir PID e TID do processo bash
# Substitua 21387 pelo PID atual do seu bash (verifique com: echo $$)
ps -o pid,tid,cmd -p 21387
