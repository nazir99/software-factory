# software-factory

A chain of agent skills that produce work and check it before a person sees it.
Each skill is one link: it does one job, and it ends with a status line the
next link (or a pipeline) can read.

## The chain

```
nsq  ->  netsuite-data-solutioning  ->  build  ->  reader-walkthrough
data      logic on the data             code       review gate
```

| Link | Job | Ends with | Status |
|---|---|---|---|
| [nsq](https://github.com/nazir99/nsq) | Get NetSuite data out read-only, prove it is complete and correctly shaped, store it safely | `NSQ: VERIFIED \| NOT VERIFIED \| BLOCKED` | Live |
| netsuite-data-solutioning | Design logic on the data, rebuild it independently, tie it out, second-model review | `SOLUTION: TIED \| NOT TIED \| UNREVIEWED` | In progress |
| reader-walkthrough | Walk the finished screen or report as its real reader and report where they stall | `VERDICT: PASS \| STALLS n` | Coming |

Supporting skill: [drawing-t-accounts](https://github.com/nazir99/drawing-t-accounts)
renders GL movement as T accounts in any medium.

## Rules every link follows

- One job per skill, with a machine-readable last line.
- Runs unattended; asks a person only before anything irreversible or production.
- A link starts only when the previous link passed.
- No client data in any repository.

## Install

```bash
git clone https://github.com/nazir99/software-factory.git
./software-factory/install.sh            # into ~/.claude/skills by default
```

Run it again to update. Each skill is also a plain folder in the open Agent Skills
format and can be cloned on its own.

## License

MIT
