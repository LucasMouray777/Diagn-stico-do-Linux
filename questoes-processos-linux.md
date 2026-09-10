# Questões — Gerenciamento de Processos no Linux

## Questão 1
```
ps -o pid,ppid,cmd
```
```
    PID    PPID CMD
  21387   21381 bash
  21396   21387 ps -o pid,ppid,cmd
```

## Questão 2
```
pstree -p 21387
```
```
bash(21387)───pstree(21419)
```

## Questão 3
```
ps -o pid,stat,cmd -p 21387
```
```
    PID STAT CMD
  21387 Ss   bash
```

## Questão 4

**1º momento**
```
ps -o pid,%cpu,%mem,cmd -p 21387
```
```
    PID %CPU %MEM CMD
  21387  0.0  0.3 bash
```

**2º momento**
```
ps -o pid,%cpu,%mem,cmd -p 21387
```
```
    PID %CPU %MEM CMD
  21387  0.0  0.3 bash
```

## Questão 5
```
ps -o pid,ni,pri,cmd -p 21387
```
```
    PID  NI PRI CMD
  21387   0  19 bash
```

```
renice -n 5 -p 21387
```
```
21387 (process ID) old priority 0, new priority 5
```

```
ps -o pid,ni,pri,cmd -p 21387
```
```
    PID  NI PRI CMD
  21387   5  14 bash
```

## Questão 6
```
ps -o pid,tid,cmd -p 21387
```
```
    PID     TID CMD
  21387   21387 bash
```

## Questão 7
```
cat /proc/21387/status
```
```
Name:	bash
Umask:	0002
State:	S (sleeping)
Tgid:	21387
Ngid:	0
Pid:	21387
PPid:	21381
TracerPid:	0
Uid:	1000	1000	1000	1000
Gid:	1000	1000	1000	1000
FDSize:	256
Groups:	4 24 27 30 46 100 113 1000
NStgid:	21387
NSpid:	21387
NSpgid:	21387
NSsid:	21387
Kthread:	0
VmPeak:	   11996 kB
VmSize:	   11996 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	    6160 kB
VmRSS:	    6160 kB
RssAnon:	    2080 kB
RssFile:	    4080 kB
RssShmem:	       0 kB
VmData:	    2020 kB
VmStk:	     132 kB
VmExe:	     972 kB
VmLib:	    1908 kB
VmPTE:	      68 kB
VmSwap:	       0 kB
HugetlbPages:	       0 kB
CoreDumping:	0
THP_enabled:	1
untag_mask:	0xffffffffffffffff
Threads:	1
SigQ:	0/7509
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000010000
SigIgn:	0000000000384004
SigCgt:	000000004b813efb
CapInh:	0000000800000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	000001ffffffffff
CapAmb:	0000000000000000
NoNewPrivs:	0
Seccomp:	0
Seccomp_filters:	0
Speculation_Store_Bypass:	vulnerable
SpeculationIndirectBranch:	always enabled
Cpus_allowed:	1
Cpus_allowed_list:	0
Mems_allowed:	00000000,...,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	322
nonvoluntary_ctxt_switches:	367
```

```
cat /proc/21387/stat
```
```
21387 (bash) S 21381 21387 21387 34816 21466 4194304 2286 6563 2 4 3 2 4 13 25 5 1 0 5985912 12283904 1516 18446744073709551615 108205301940224 108205302933613 140731861308576 0 0 0 65536 3686404 1266761467 1 0 0 17 0 0 0 0 0 0 108205303245584 108205303293808 108205472002048 140731861310099 140731861310104 140731861310104 140731861311470 0
```

```
cat /proc/21387/cmdline
```
```
bash
```

```
cat /proc/21387/limits
```
```
Limit                     Soft Limit           Hard Limit           Units
Max cpu time              unlimited            unlimited            seconds
Max file size             unlimited            unlimited            bytes
Max data size             unlimited            unlimited            bytes
Max stack size            8388608              unlimited            bytes
Max core file size        0                    unlimited            bytes
Max resident set          unlimited            unlimited            bytes
Max processes             7509                 7509                 processes
Max open files            1024                 524288               files
Max locked memory         8388608              8388608              bytes
Max address space         unlimited            unlimited            bytes
Max file locks            unlimited            unlimited            locks
Max pending signals       7509                 7509                 signals
Max msgqueue size         819200               819200               bytes
Max nice priority         0                    0
Max realtime priority     0                    0
Max realtime timeout      unlimited            unlimited            us
```

## Questão 8
```
sleep 300 &
```
```
[1] 21578
```

```
ps -o pid,stat,cmd -p 21578
```
```
    PID STAT CMD
  21578 SN   sleep 300
```

```
kill -19 21578
```
```
[1]+  Stopped                 sleep 300
```

```
ps -o pid,stat,cmd -p 21578
```
```
    PID STAT CMD
  21578 TN   sleep 300
```

```
kill -18 21578
```

```
ps -o pid,stat,cmd -p 21578
```
```
    PID STAT CMD
  21578 SN   sleep 300
```

```
kill -15 21578
```
```
bash: kill: (21578) - No such process
[1]+  Done                    sleep 300
```
