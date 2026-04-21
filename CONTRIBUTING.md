# Contributing to Paperclip AI Home Assistant Add-on

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Getting Started

### Prerequisites

- Home Assistant OS or Supervised
- Git
- Basic knowledge of Docker and Home Assistant add-ons
- Familiarity with bash scripting

### Development Workflow

1. **Fork the Repository**

   Fork this repository on GitHub and clone your fork locally.

2. **Create a Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**

   - Edit files in the `paperclip_ha_addon/` directory
   - Test your changes locally
   - Update documentation if needed

4. **Test Your Changes**

   - Build the add-on locally
   - Test on Home Assistant
   - Verify all features work as expected

5. **Commit Changes**

   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. **Push and Create Pull Request**

   ```bash
   git push origin feature/your-feature-name
   ```

   Then create a pull request on GitHub.

## Code Style

### Shell Scripts

- Use 4 spaces for indentation
- Follow bash best practices
- Use `bashio` functions for Home Assistant integration
- Add comments for complex logic

### JSON Configuration

- Use 2 spaces for indentation
- Keep keys in alphabetical order where practical
- Add comments in documentation, not in JSON

### Documentation

- Use clear, concise language
- Include examples for complex configurations
- Update README.md for user-facing changes
- Update inline code comments for developer-facing changes

## Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add PostgreSQL connection pooling
fix: resolve database migration issue
docs: update installation instructions
```

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows the project's style guidelines
- [ ] Commit messages follow the conventional commits format
- [ ] Documentation is updated
- [ ] Changes are tested on Home Assistant
- [ ] No unnecessary files or changes are included

### Pull Request Description

Include:

- **Why**: What problem does this PR solve?
- **What**: What changes are included?
- **How**: How was this tested?
- **Screenshots**: If applicable, include screenshots

### Review Process

1. Automated checks must pass
2. At least one maintainer review
3. All feedback addressed
4. Approval before merge

## Testing

### Local Testing

1. Copy the add-on to your Home Assistant add-ons directory
2. Restart Home Assistant
3. Install and configure the add-on
4. Test all features
5. Check logs for errors

### Testing Checklist

- [ ] Add-on installs successfully
- [ ] Add-on starts without errors
- [ ] Web UI is accessible
- [ ] Configuration options work correctly
- [ ] Database connections work (SQLite and PostgreSQL)
- [ ] OpenClaw integration works (if applicable)
- [ ] Logs show no errors
- [ ] Add-on stops cleanly

## Reporting Issues

When reporting issues, include:

- Home Assistant version
- Add-on version
- Architecture (aarch64/amd64)
- Steps to reproduce
- Expected behavior
- Actual behavior
- Relevant logs

## Feature Requests

For feature requests:

- Check existing issues first
- Describe the use case clearly
- Explain why this feature would be valuable
- Consider if it fits the project's scope

## Questions

For questions:

- Check documentation first
- Search existing issues
- Use GitHub Discussions (if available)
- Be specific and provide context

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Code of Conduct

Please be respectful and constructive. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details.

---

Thank you for contributing! 🎉