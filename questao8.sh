#!/bin/bash
# Questão 8 - Testar sinais de controle de job (SIGSTOP, SIGCONT, SIGTERM)

sleep 300 &
PID=$!

echo "Processo criado com PID: $PID"
ps -o pid,stat,cmd -p $PID

echo "Enviando SIGSTOP (kill -19)..."
kill -19 $PID
ps -o pid,stat,cmd -p $PID

echo "Enviando SIGCONT (kill -18)..."
kill -18 $PID
ps -o pid,stat,cmd -p $PID

echo "Enviando SIGTERM (kill -15)..."
kill -15 $PID
