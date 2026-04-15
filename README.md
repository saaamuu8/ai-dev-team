# AI Dev Team

4 AI agents that cover the full stack of a production project. Each one reads your `CLAUDE.md` to understand your stack and conventions, then applies deep expertise in its domain.

Works with any language, framework, or architecture.

## Install

```bash
git clone git@github.com:SamuelOctoCam/ai-dev-team.git /tmp/ai-dev-team

# Install into your project
/tmp/ai-dev-team/install.sh .
```

This copies all agents to `.claude/agents/` and skills to `.claude/skills/` inside your project. Claude Code detects them automatically.

The installer also configures project-scoped MCP servers (Stripe, Postgres) if the `claude` CLI is available.

## The Team

| Agent | When to use |
| ----- | ----------- |
| `fullstack-architect` | Design features, review PRs, audit architecture, API contracts, type safety, docs, plan migrations/refactors |
| `frontend-quality` | Accessibility (WCAG 2.1 AA/AAA), design system consistency, Core Web Vitals, SEO, E2E tests with Playwright |
| `backend-platform` | Database & queries, event-driven systems, third-party integrations, CI/CD, observability, integration tests |
| `critical-systems` | Auth/authz (JWT, OAuth, RBAC, IDOR), app security, billing flows (Stripe/Paddle/Lemon Squeezy) |

## Usage

### Architecture & Code Review

```bash
# Audit the full repository architecture
claude "Audit the entire repository" --agent fullstack-architect

# Review a PR or recent changes
claude "Review my last 3 commits as a tech lead" --agent fullstack-architect

# Plan a large refactor or migration
claude "Plan the migration from Next.js 13 to 15" --agent fullstack-architect

# Audit API contracts
claude "Audit all REST endpoints for consistency and correctness" --agent fullstack-architect

# Find type safety issues
claude "Find all 'any' types, unsafe assertions and missing return types" --agent fullstack-architect
```

### Frontend Quality

```bash
# Full accessibility audit
claude "Find all WCAG 2.1 AA violations" --agent frontend-quality

# Core Web Vitals and performance
claude "Analyze bundle size and find render bottlenecks" --agent frontend-quality

# SEO audit
claude "Audit technical SEO across all pages" --agent frontend-quality

# Write E2E tests for a critical flow
claude "Write Playwright E2E tests for the checkout flow" --agent frontend-quality

# Design system consistency
claude "Find inconsistencies in spacing, colors and component variants" --agent frontend-quality
```

### Backend & Platform

```bash
# Database optimization
claude "Find N+1 queries, missing indices and slow queries" --agent backend-platform

# Audit event-driven systems
claude "Audit all queues and async flows for reliability issues" --agent backend-platform

# Third-party integrations review
claude "Audit all third-party integrations for resilience and error handling" --agent backend-platform

# Observability gaps
claude "What is missing for production observability?" --agent backend-platform

# Write integration tests
claude "Write integration tests for the UserService" --agent backend-platform
```

### Security & Billing

```bash
# Full security scan
claude "Find all security vulnerabilities" --agent critical-systems

# Auth audit
claude "Audit all authentication and authorization flows" --agent critical-systems

# Billing integrity review
claude "Audit the entire billing system for race conditions, double-grants and missing idempotency" --agent critical-systems

# Webhook security
claude "Review all webhook handlers for signature verification and idempotency" --agent critical-systems
```

### Weekly Maintenance

```bash
claude "Full architecture audit, report CRITICAL and HIGH only" --agent fullstack-architect
claude "Full security scan" --agent critical-systems
claude "Find slow queries and missing indices" --agent backend-platform
claude "Find all WCAG 2.1 AA violations" --agent frontend-quality
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and configured
- A `CLAUDE.md` in your project root (strongly recommended — helps agents understand your stack, conventions and architectural decisions)

## MCP Servers

The installer configures two project-scoped MCP servers automatically:

| MCP | Used by | Purpose |
| --- | ------- | ------- |
| **Stripe** | `critical-systems` | Inspect customers, subscriptions, invoices, webhook events |
| **Postgres** | `backend-platform`, `critical-systems` | Run `EXPLAIN ANALYZE`, inspect schema, check constraints |

Run `/mcp` inside Claude Code after installing to authenticate.

## Customization

Each agent is a single markdown file in `.claude/agents/`. Edit any of them to add project-specific rules, adjust severity levels, or change the report format.

## License

MIT
