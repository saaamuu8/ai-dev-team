# AI Dev Team

21 AI agents that act as a complete development team for any repository. Each agent is a specialist that reads your project's `CLAUDE.md` to understand the stack, then applies its expertise.

Works with any language, framework, or architecture.

## Install

```bash
git clone git@github-personal:saaamuu8/ai-dev-team.git /tmp/ai-dev-team

# Then install into your project
/tmp/ai-dev-team/install.sh .
```

This copies all agents to `.claude/agents/` inside your project. Claude Code detects them automatically.

## The Team

### Backend

| Agent           | Specialty                                                    |
| --------------- | ------------------------------------------------------------ |
| `architect`     | Architecture patterns, dependencies, SOLID, bounded contexts |
| `database`      | Queries, indices, N+1, migrations, transactions              |
| `security`      | Vulnerabilities, secrets, injections, CORS, rate limiting    |
| `api-contract`  | REST/GraphQL design, DTOs, status codes, versioning          |
| `billing`       | Payment flows, webhooks, subscriptions, credit systems       |
| `auth`          | JWT, sessions, OAuth, RBAC, IDOR, password flows             |
| `event-driven`  | Queues, Kafka/SQS/RabbitMQ, idempotency, sagas, DLQ         |
| `integrations`  | Third-party SDKs, webhooks, retries, circuit breakers, rate limits |

### Frontend

| Agent           | Specialty                                                 |
| --------------- | --------------------------------------------------------- |
| `ui-architect`  | Component structure, state management, routing, data flow |
| `design-system` | Visual consistency, tokens, dark mode, responsive         |
| `performance`   | Bundle size, lazy loading, renders, Core Web Vitals       |
| `accessibility` | WCAG 2.1 AA/AAA, ARIA, keyboard nav, screen readers       |
| `seo`           | Meta tags, structured data, crawlability, SSR/SSG         |

### Quality

| Agent              | Specialty                                              |
| ------------------ | ------------------------------------------------------ |
| `test-unit`        | Unit tests, edge cases, mocks, coverage gaps           |
| `test-e2e`         | End-to-end flows, critical user journeys               |
| `test-integration` | Service layer tests, DB integration, contract testing  |

### Infrastructure

| Agent           | Specialty                                              |
| --------------- | ------------------------------------------------------ |
| `infra`         | Docker, CI/CD, cloud config, health checks, backups    |
| `observability` | Logging, metrics, traces, SLOs, alerts, runbooks       |

### Developer Experience

| Agent           | Specialty                                              |
| --------------- | ------------------------------------------------------ |
| `type-safety`   | Eliminate unsafe patterns, strict mode, type guards    |
| `code-reviewer` | Pre-PR review, naming, complexity, DRY, dead code      |
| `documentation` | README, API docs, onboarding, changelog                |
| `migration`     | Dependency upgrades, framework migrations, codemods    |

## Usage

### Audits

```bash
# Full architecture audit
claude "Audit the entire repository" --agent architect

# Security scan
claude "Find all security vulnerabilities" --agent security

# Auth flows review
claude "Audit all authentication and authorization flows" --agent auth

# Database optimization
claude "Find N+1 queries and missing indices" --agent database

# Frontend performance
claude "Analyze bundle size and find render bottlenecks" --agent performance

# Accessibility audit
claude "Find all WCAG 2.1 AA violations" --agent accessibility

# SEO audit
claude "Audit technical SEO across all pages" --agent seo

# Third-party integrations audit
claude "Audit all third-party integrations for resilience and security" --agent integrations

# Observability gaps
claude "What is missing for production observability?" --agent observability

# Event-driven systems
claude "Audit all queues and async flows for reliability issues" --agent event-driven
```

### Fixes

```bash
# Fix architecture violations
claude "Fix all critical architecture violations. Make separate commits for each fix." --agent architect

# Fix type safety issues
claude "Eliminate all 'any' types and 'as' assertions" --agent type-safety

# Fix accessibility issues
claude "Fix all WCAG 2.1 AA violations" --agent accessibility
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

# Integration tests for the service layer
claude "Write integration tests for UserService" --agent test-integration

# E2E tests for critical flows
claude "Write E2E tests for the checkout flow" --agent test-e2e
```

### Migrations & Upgrades

```bash
# Plan a dependency upgrade
claude "Plan the migration from Next.js 13 to 15" --agent migration

# Execute a framework migration
claude "Migrate all class components to hooks" --agent migration
```

### Documentation

```bash
# Audit docs
claude "What documentation is missing or outdated?" --agent documentation

# Generate API docs
claude "Document all API endpoints" --agent documentation
```

### Weekly Maintenance

```bash
claude "Full audit, report only CRITICAL and HIGH issues" --agent architect
claude "Full security scan" --agent security
claude "Find slow queries and missing indices" --agent database
claude "Check infrastructure and observability gaps" --agent infra
claude "Check monitoring, SLOs and alert coverage" --agent observability
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and configured
- A `CLAUDE.md` in your project root (recommended — helps agents understand your stack and conventions)

## Customization

Each agent is a markdown file installed to `.claude/agents/`. Edit any agent to:

- Add project-specific rules
- Adjust severity levels
- Change report format
- Add or remove checks

## License

MIT
