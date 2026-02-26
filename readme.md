# Curriculum Architect — Human-in-the-Loop Pipeline

An n8n workflow that generates structured, semester-long curriculums using an LLM, then pauses for human approval before proceeding — a true async Human-in-the-Loop (HITL) gate.

![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-orange)
![Ollama](https://img.shields.io/badge/Ollama-Mistral%207B-blue)
![Status](https://img.shields.io/badge/Status-POC%20Complete-green)

## Demo

🎥 [Watch the 3-minute walkthrough on Loom](https://www.loom.com/share/74048060e3c64697855631763290ff77)

## What It Does

1. Takes project inputs (title, grade level, competency map)
2. An LLM generates a JSON array of 10 sequential curriculum sessions, each mapped to specific skill IDs
3. The workflow **pauses execution** and waits for a human Curriculum Director to review and approve/reject
4. Routes to the next stage (generation loop) or ends the run based on the decision

## Architecture

```
Manual Trigger → Mock Inputs → Curriculum Architect (LLM) → Build Review Page → Wait (HITL Gate) → IF Router
                                        │                                                            ├── ✅ Proceed to Generation Loop
                                        │                                                            └── ❌ End Run / Request Revision
                                   Ollama/Mistral
```

## Key Design Decisions

### Open-Source LLM (Ollama + Mistral 7B)
Used a locally-running open-source model instead of a paid API. This keeps the pipeline cost-free, self-contained, and fully reproducible on any machine without API keys.

### Constrained Prompt Engineering
The prompt enforces a strict JSON schema — 10 sessions, each with `session_id`, `session_title`, and `mapped_skill_id`. The model is constrained to only use the three exact skill IDs from the provided Competency Map (SC.5.1, SC.5.2, SC.5.3). No hallucinated codes, no nulls.

### Async HITL via Webhook
The Wait node in webhook mode genuinely halts execution — not a timer, not polling. The workflow stays paused indefinitely until a human hits the approve or reject webhook URL. In production, this URL would be delivered via email or Slack with an embedded review form.

### Clean Binary Routing
An IF node checks the `decision` query parameter from the webhook. Approve routes to the generation loop, anything else routes to revision. Simple, predictable, no ambiguity.

## Sample LLM Output

```json
[
  { "session_id": 1, "session_title": "Introduction to Sustainable Mars Colony", "mapped_skill_id": "SC.5.1" },
  { "session_id": 2, "session_title": "Exploring Martian Ecosystems", "mapped_skill_id": "SC.5.1" },
  { "session_id": 3, "session_title": "Designing a Water Collection System", "mapped_skill_id": "SC.5.2" },
  { "session_id": 4, "session_title": "Building a Solar Powered Water Purifier", "mapped_skill_id": "SC.5.2" },
  { "session_id": 5, "session_title": "Understanding Thermal Insulation on Mars", "mapped_skill_id": "SC.5.3" },
  { "session_id": 6, "session_title": "Designing a Martian Habitat with Thermal Insulation", "mapped_skill_id": "SC.5.3" },
  { "session_id": 7, "session_title": "Exploring Materials for Martian Housing", "mapped_skill_id": "SC.5.3" },
  { "session_id": 8, "session_title": "Creating a Greenhouse for Mars", "mapped_skill_id": "SC.5.1" },
  { "session_id": 9, "session_title": "Mars Rover Challenge: Testing Our Designs", "mapped_skill_id": "SC.5.2" },
  { "session_id": 10, "session_title": "Review and Presentation of Mars Colony Project", "mapped_skill_id": "SC.5.1" }
]
```

## Setup — Local

### Prerequisites
- [Node.js](https://nodejs.org/) (LTS)
- [Ollama](https://ollama.com/) with Mistral model

### Steps

```bash
# 1. Install and start Ollama, pull Mistral
ollama pull mistral

# 2. Install n8n
npm install n8n -g

# 3. Start n8n
n8n start

# 4. Open http://localhost:5678
# 5. Import the workflow: workflow/Curriculum_Architect_HITL_Workflow.json
# 6. Add Ollama credential (Base URL: http://127.0.0.1:11434)
# 7. Execute the workflow
```

## Setup — Docker

```bash
# Clone the repo
git clone https://github.com/ThiruDeepak2311/curriculum-architect-hitl.git
cd curriculum-architect-hitl

# Copy and configure environment
cp .env.example .env

# Start services
docker compose up -d

# Open http://localhost:5678 and import the workflow
```

## Project Structure

```
curriculum-architect-hitl/
├── .gitignore
├── .env.example            # Environment variable template
├── docker-compose.yml      # Docker setup for n8n + Postgres
├── README.md
└── workflow/
    └── Curriculum_Architect_HITL_Workflow.json   # n8n workflow export
```

## Tech Stack

- **n8n** — Workflow automation platform
- **Ollama** — Local LLM runtime
- **Mistral 7B** — Open-source language model
- **Docker + Postgres** — Production deployment

## Author

**Deepak Thirukkumaran**
- GitHub: [@ThiruDeepak2311](https://github.com/ThiruDeepak2311)