# ELI - Project Guidelines

## Build & Test Commands
- Build: `npm run build`
- Lint: `npm run lint`
- TypeCheck: `npm run typecheck`
- Test (all): `npm run test`
- Test (single): `npm test -- -t "test name"` 

## Code Style Guidelines
- TypeScript with strict typing
- Format with Prettier: `npm run format`
- Imports: group and sort alphabetically (built-in, external, internal)
- Naming: camelCase for variables/functions, PascalCase for classes/components
- Error handling: use try/catch with specific error types
- Comments: explain "why" not "what"
- Prefer async/await over Promises
- Use functional programming patterns where appropriate
- Use React for UI components
- Avoid any type, use proper typing

This document will be automatically loaded into Claude's context when working in this repository.