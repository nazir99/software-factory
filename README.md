# software-factory

**AI can build finance tools quickly. The hard part is trusting what it built.**

This is a set of instructions for AI coding assistants (Claude Code, Codex and
similar). They make the assistant prove its own NetSuite work before a person
reviews it. The assistant pulls the data, proves the numbers against NetSuite's
own figures and checks that the result is easy to read. Every step ends in a
plain pass or fail.

Status as of 2026-10-01: steps 1, 2 and 4 are published and in use on a live
NetSuite costing project. Step 3 is ordinary development, so it has no repository.

## How it works: four steps

| Step | What happens | It ends with | Repository |
|---|---|---|---|
| 1. Get the data | Pulls the data out of NetSuite without changing anything. Checks that nothing is missing and that it foots to a NetSuite figure. | **Verified**, **not verified** (with the reason) or **blocked** | [nsq](https://github.com/nazir99/nsq) |
| 2. Prove the logic | Writes the business rule in plain words. Rebuilds the calculation separately and ties it out to NetSuite's own figures. A second AI then tries to break it. | **Tied**, **not tied** (how many rows did not match) or **unreviewed** | [netsuite-data-solutioning](https://github.com/nazir99/netsuite-data-solutioning) |
| 3. Build | Ordinary development: the screen, report or feed. Not a separate repository. | Deployed | none |
| 4. Reader review | Reads the finished screen or report the way its real reader will. Reports every point where that reader would get stuck. | **Pass**, or **stalls** with the worst one named | [reader-walkthrough](https://github.com/nazir99/reader-walkthrough) |

A step starts only when the step before it passed.

One helper skill installs with the set:
[drawing-t-accounts](https://github.com/nazir99/drawing-t-accounts) shows how cost
or money moved through GL accounts as T accounts.

## What it caught on its first real run

The first run was a cost-pool screen for a manufacturer, showing the average cost
ledger per item and location. Client names and amounts are left out.

- **Five calculation defects found** in a screen that was already in use,
  including landed cost at the wrong amount and revaluations valued incorrectly.
- **A test that looked complete was not.** It skipped every zero-stock and
  standard-cost pool.
- **A rule that "matched" was rejected.** It was fitted on one pool, made 19
  of 227 other pools worse, and was not shipped.
- **Result (production, 2026-09-28):** 15,727 of 15,729 pools end exactly on
  NetSuite's own inventory value for that item and location.
  The 2 that do not are a gap inside NetSuite itself (location value vs GL after
  backdated entries), not in the calculation.

## The rules every step follows

- **It never changes NetSuite data.** Every step only reads from NetSuite.
- **Sandbox first.** A step uses production data only when a person asked for it
  in that task.
- **Nothing is called right until it is proven against an independent figure.** A
  check that only compares the work with itself does not count.
- **It says what it did not check.** "Not verified" and "unreviewed" are real
  answers, not failures to hide.
- **No client data in any repository.**

## Who reads what

| You are | Read |
|---|---|
| Deciding whether to trust the output | This page, then the "Why" section of each step's README |
| Installing it | [Install](#install) below |
| An AI assistant | Each repository's `SKILL.md`. Those files are written for the AI, not for people. |

## Install

```bash
git clone https://github.com/nazir99/software-factory.git
./software-factory/install.sh            # installs every step into ~/.claude/skills
```

Run it again to update. Step 1 also ships a command-line tool. Its README covers
the one-time NetSuite setup.

## For pipelines: the exact result lines

Each step's last line is fixed, so a script can read it:

```
NSQ: VERIFIED <rows> rows from <alias> [<env>] | NOT VERIFIED <reason> | BLOCKED <reason>
SOLUTION: TIED | NOT TIED <n unmatched | no tie-out> | UNREVIEWED <reason>
VERDICT: PASS | STALLS <count> | worst: <Where>
```

## License

MIT
