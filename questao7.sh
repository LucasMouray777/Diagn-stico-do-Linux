#!/bin/bash
# Questão 7 - Exibir informações detalhadas do processo bash via /proc
# Substitua 21387 pelo PID atual do seu bash (verifique com: echo $$)

cat /proc/21387/status
echo "---"
cat /proc/21387/stat
echo "---"
cat /proc/21387/cmdline
echo "---"
cat /proc/21387/limits
