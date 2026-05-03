# Belle's Agentic Tutor

A personalised study companion for Belle, powered by the [Agentic Tutor](https://github.com/dominicpedro/agentic-tutor) framework.

## Student Profile

- **Name:** Belle
- **Grade:** 5
- **Country:** South Africa
- **Curriculum:** CAPS (Curriculum and Assessment Policy Statement)

## Project Structure

```
belles-tutor/
├── CLAUDE.md                     ← You are here (student overview)
├── .claude/
│   ├── .shared/                  ← git submodule → agentic-tutor (framework)
│   ├── agents/                   ← symlinks to tutor agents
│   ├── commands/                 ← symlinks to tutor skills
│   └── rules/                    ← symlinks to tutor rules + local math.md
├── sync-claude.sh                ← Refresh symlinks from submodule
├── uploads/                      ← All scanned/photographed source pages
│   └── <subject>/                ← Organized by subject (lowercase)
├── <Subject>/                    ← One folder per subject
│   ├── CLAUDE.md                 ← Subject-specific context
│   ├── summaries/                ← Per-page structured summaries
│   │   ├── patterns-and-issues.md ← Running error tracker
│   │   └── demarcation.md        ← Test/exam scope
│   ├── notes/                    ← Study notes and quick cards
│   ├── sessions/                 ← Session logs
│   └── tests/                    ← Practice tests and mark sheets
```

## Available Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| Study Session | `/study-session` | Interactive tutoring on a topic |
| Spot Test | `/spot-test` | Quick-fire quiz, 5-10 rapid questions |
| Generate Test | `/generate-test` | Create practice tests, mark and review |
| Study Notes | `/study-notes` | Generate consolidated study notes |
| Study Plan | `/study-plan` | Day-by-day study schedule |
| Parent Check | `/parent-check` | Readiness assessment for parents |
| Process Workbook | `/process-workbook` | Batch-process photographed pages |
| Pause | `/pause` | Save session state for later |
| Continue | `/continue` | Resume a paused session |

## Learning Style

Belle's thinking patterns and the "named method" approach are documented in `learning-style.md`. **Read this before any session.** It covers:

- How she thinks (non-linear, head-math, working memory bottleneck)
- The named method system (trigger names, written + typed formats)
- Session rules (always prompt for working, use shorthand, stop at fatigue)
- Current named methods and their quick cards

## Getting Started

1. Read `learning-style.md` to understand how Belle learns
2. Read `patterns-and-issues.md` in the relevant subject to understand current strengths/weaknesses
3. Use `/study-session` for guided practice or `/spot-test` for quick drills
4. After each session, the tutor updates `patterns-and-issues.md` automatically

## Adding a New Subject

1. Create a folder: `<Subject>/`
2. Add a `CLAUDE.md` inside it with curriculum context
3. Create `uploads/<subject>/` for source material and `<Subject>/summaries/` for output
4. Use `/process-workbook` to batch-process material

## Submodule Updates

To pull the latest tutor framework:
```bash
git submodule update --remote
./sync-claude.sh
```

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:

- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
