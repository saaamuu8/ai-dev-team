# AI Dev Team

14 AI agents that act as a complete development team for any repository. Each agent is a specialist that reads your project's `CLAUDE.md` to understand the stack, then applies its expertise.

Works with any language, framework, or architecture.

## Install

```bash
git clone https://github.com/your-org/ai-dev-team.git /tmp/ai-dev-team
/tmp/ai-dev-team/install.sh /path/to/your-project
```

This copies all agents to `.claude/agents/` inside your project. Claude Code detects them automatically.

## The Team

### Backend

| Agent          | Specialty                                                    |
| -------------- | ------------------------------------------------------------ |
| `architect`    | Architecture patterns, dependencies, SOLID, bounded contexts |
| `database`     | Queries, indices, N+1, migrations, transactions              |
| `security`     | Vulnerabilities, auth, secrets, injections, rate limiting    |
| `api-contract` | REST/GraphQL design, DTOs, status codes, versioning          |
| `billing`      | Payment flows, webhooks, subscriptions, credit systems       |

### Frontend

| Agent           | Specialty                                                 |
| --------------- | --------------------------------------------------------- |
| `ui-architect`  | Component structure, state management, routing, data flow |
| `design-system` | Visual consistency, tokens, accessibility, responsive     |
| `performance`   | Bundle size, lazy loading, renders, Core Web Vitals       |

### Quality

| Agent       | Specialty                                           |
| ----------- | --------------------------------------------------- |
| `test-unit` | Unit tests, edge cases, mocks, coverage gaps        |
| `test-e2e`  | End-to-end flows, integration tests, critical paths |

### Infrastructure

| Agent   | Specialty                                              |
| ------- | ------------------------------------------------------ |
| `infra` | Docker, CI/CD, cloud config, monitoring, health checks |

### Developer Experience

| Agent           | Specialty                                           |
| --------------- | --------------------------------------------------- |
| `type-safety`   | Eliminate unsafe patterns, strict mode, type guards |
| `code-reviewer` | Pre-PR review, naming, complexity, DRY, dead code   |
| `documentation` | README, API docs, onboarding, changelog             |

## Usage

### Audits

```bash
# Full architecture audit
claude "Audit the entire repository" --agent architect

# Security scan
claude "Find all security vulnerabilities" --agent security

# Database optimization
claude "Find N+1 queries and missing indices" --agent database

# Frontend performance
claude "Analyze bundle size and find render bottlenecks" --agent performance
```

### Fixes

```bash
# Fix architecture violations
claude "Fix all critical architecture violations. Make separate commits for each fix." --agent architect

# Fix type safety issues
claude "Eliminate all 'any' types and 'as' assertions" --agent type-safety

# Fix accessibility issues
claude "Fix all WCAG 2.1 AA violations" --agent design-system
```

### Code Review

```bash
# Review recent changes
claude "Review my last 3 commits" --agent code-reviewer

# Review a specific file
claude "Review src/billing/checkout.service.ts" --agent code-reviewer
```

### Write Tests

```bash
# Unit tests for a module
claude "Write unit tests for the auth module" --agent test-unit

# E2E tests for critical flows
claude "Write E2E tests for the checkout flow" --agent test-e2e
```

### Documentation

```bash
# Audit docs
claude "What documentation is missing or outdated?" --agent documentation

# Generate API docs
claude "Document all API endpoints" --agent documentation

# Write onboarding guide
claude "Write an onboarding guide for new developers" --agent documentation
```

### Weekly Maintenance

```bash
# Run all audits
claude "Full audit, report only CRITICAL and HIGH issues" --agent architect
claude "Full security scan" --agent security
claude "Find slow queries and missing indices" --agent database
claude "Check infrastructure configuration" --agent infra
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and configured
- A `CLAUDE.md` in your project root (recommended — helps agents understand your stack and conventions)

## Customization

Each agent is a markdown file in `.claude/agents/`. Edit any agent to:

- Add project-specific rules
- Adjust severity levels
- Change report format
- Add or remove checks

## License

MIT
