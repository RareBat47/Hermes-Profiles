---
name: hermes-profile-provider-config
description: "Use when configuring Hermes profile providers."
version: 1.0.0
category: autonomous-ai-agents
metadata:
  hermes:
    tags: [hermes, profiles, providers, models, configuration, isolation]
    related_skills: [profile-generator, hermes-agent]
---

# Hermes Profile Provider Configuration

Configure and troubleshoot model-provider visibility for named Hermes profiles. A
profile is an isolated Hermes home: its configuration, secret environment, model
catalog state, sessions, skills, and memory must be treated as separate from the
home profile.

## Procedure

### 1. Identify the active profile and its real home

Use the target profile's explicit home for every inspection and configuration
command. Do not infer the target profile's state from the default profile.

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config path
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config show
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config get model
```

On Windows shells where `$LOCALAPPDATA` is not exported, use the absolute profile
path with forward slashes. Confirm the reported Config and Secrets paths point
inside the named profile before changing anything.

### 2. Inspect the provider in the target profile

For a named custom provider, query the exact configured name and preserve its
spelling and case while diagnosing:

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config get providers.<ProviderName>
```

Also inspect the target profile's environment path without exposing the secret:

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config env-path
```

A provider found only in the home profile's `config.yaml` is not evidence that a
named profile can use it. Profiles do not automatically inherit provider entries
or credentials from the home profile.

### 3. Add or repair the provider through Hermes configuration

Use `hermes config set` under the target profile rather than hand-editing the
whole YAML file:

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set providers.<ProviderName>.base_url 'https://provider.example/v1'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set providers.<ProviderName>.key_env '<PROFILE_PROVIDER_KEY_ENV>'
```

Keep credentials in the profile's supported secret environment or credential
lifecycle. Never paste an API key into a conversation, a command argument, or
`config.yaml`; `key_env` is only a reference to the secret variable.

### 4. Select the provider using its runtime identity

Named custom providers are addressed by the runtime as:

```text
custom:<ProviderName>
```

The Hermes profile name is not an inference provider. For example, a profile
named `redsage` can use a provider named `REDSAGEapi`, but the provider identity
is `custom:REDSAGEapi`, not `redsage`.

Set the profile's default explicitly when required:

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.provider 'custom:<ProviderName>'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.default '<model-id>'
```

### 5. Add task-oriented aliases when several role providers share an endpoint

When a gateway exposes separate keys or quotas for planning, coding tiers,
hybrid work, and debugging, create one named provider per role and one short
model alias per task. Keep the provider identity and model explicit; do not
encode a role only in prose or rely on a shared gateway key.

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.aliases.planning 'custom:Planning/<planning-model>'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.aliases.coding-1 'custom:Coding-1/<fast-model>'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.aliases.coding-2 'custom:Coding-2/<general-model>'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.aliases.coding-3 'custom:Coding-3/<high-tier-model>'
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config set model.aliases.debugging 'custom:Debugging/<debug-model>'
```

Use a consistent task vocabulary (`planning`, `coding-1`, `coding-2`,
`coding-3`, `hybrid-1`, `hybrid-2`, `debugging`) and document the mapping in
the completion report so the user can switch with `/model <alias>`.

### 6. Verify in the same profile context

Run all checks against the target profile, not only the home profile:

```bash
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config get providers.<ProviderName>
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config get model
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config get model.aliases
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes config check
HERMES_HOME="$LOCALAPPDATA/hermes/profiles/<profile>" hermes doctor
```

Then verify each configured role independently: call the endpoint's `/models`
route with that role's credential, followed by one bounded, non-streaming
`/chat/completions` smoke request using the exact role model. Treat provider
configuration, alias resolution, authorization, and successful inference as
separate acceptance checks; a successful `/models` response alone is not proof
that chat inference works.

## Pitfalls

- **Do not confuse profile and provider names:** a profile selects a provider;
  it does not become one, so the picker lists `custom:<ProviderName>` rather
  than the profile name.
- **Do not specify custom provider models via `--model custom:<ProviderName>/<model>`:**
  the CLI parser can treat `custom` as the provider and route the request to the
  default custom gateway (producing HTTP 404 `Model 'custom:...' does not exist or is disabled`).
  Always pass `--provider custom:<ProviderName> --model <model>` explicitly or invoke
  a configured short alias from `model.aliases` via `-m <alias>`.
- **Do not configure remote MCP servers interactively in automated scripts:**
  running `hermes mcp add <name> --url <endpoint>` prompts interactively
  (`Does this server require authentication? [Y/n]:`) and blocks headless execution.
  Instead, configure remote MCP endpoints directly under `mcp_servers.<name>` in
  `config.yaml` (`url: ...`, `enabled: true`) and verify connectivity non-interactively
  with `hermes mcp test <name>`.
- **Do not verify a named profile from the default home:** the same provider can
  exist globally while being absent from the profile's isolated config and secret
  environment.
- **Do not treat cached model metadata as configuration:** a cached `/models`
  response can show models for an endpoint without proving that the current
  profile has a provider entry, credential, or active route.
- **Do not assume a configured `key_env` is a loaded credential:** verify the
  target profile's secret path and run the profile-scoped connectivity check,
  because an environment variable in another profile does not satisfy this one.
- **Do not assume role keys are interchangeable across a gateway:** verify each key against the gateway's allowed models/families; sending a model with an unpermitted key produces HTTP 403 (`Model '...' is not permitted for API key`). Run live smoke tests with the exact target model per role.
- **Do not hand-edit provider YAML for routine changes:** `hermes config set`
  preserves Hermes' configuration handling and avoids malformed indentation or
  writing secrets into settings.
- **Do not copy credentials from an integration note into `config.yaml` or a
  command line:** put each role key in the profile secret store and reference it
  with a distinct `key_env`, because shell history and configuration output can
  expose inline keys.
- **Do not validate only the shared gateway key or endpoint:** test every role's
  own `/models` and chat route, because role-specific authorization and model
  allowlists can differ even when all providers use one base URL.
- **Do not claim a role alias is usable from configuration alone:** resolve the
  alias and run a bounded inference request, because an alias can point to a
  valid-looking but unauthorized model/provider pair.

## Acceptance checklist

- [ ] Target config and secret paths are inside the intended profile.
- [ ] Exact provider entry exists in that profile.
- [ ] Provider uses a base URL and a secret reference, not an inline secret.
- [ ] Runtime identity is `custom:<ProviderName>`.
- [ ] Profile default model/provider or picker selection is correct.
- [ ] Profile-scoped doctor/connectivity or smoke verification was run.
- [ ] Any remaining failure is reported as an environment/credential blocker,
      not as provider absence.
