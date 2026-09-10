#!/bin/bash
# Questão 4 - Exibir uso de CPU e memória do processo bash em dois momentos
# Substitua 21387 pelo PID atual do seu bash (verifique com: echo $$)

echo "1º momento:"
ps -o pid,%cpu,%mem,cmd -p 21387

sleep 5

echo "2º momento:"
ps -o pid,%cpu,%mem,cmd -p 21387
