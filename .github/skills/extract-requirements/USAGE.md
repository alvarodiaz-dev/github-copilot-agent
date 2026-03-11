# How the Agent Uses This Skill

## Automatic Detection

The agent **automatically** loads this skill when:
1. Your prompt contains keywords matching the skill's `description` field:
   - "extract requirements"
   - "parse requirements file"
   - "structure microservice details"
   - "requirements into JSON"

2. The skills folder is in the correct location: `.github/skills/extract-requirements/`

3. The SKILL.md has proper YAML frontmatter with `name` and `description`

**How it works:** The agent scans the description field for trigger phrases. If your request matches, the skill is loaded and its workflow becomes available.

## Integration with C# Microservice Generator

The extract-requirements skill works **upstream** of the C# Microservice Generator agent:

```
requirements.md
    ↓
[extract-requirements skill] ← You invoke this
    ↓
requirements.structured.json
    ↓
[C# Microservice Generator agent] ← Pass JSON as input
    ↓
Generated microservices + GitHub publication
```

### Workflow Example

**Step 1: Extract requirements (use this skill)**
```
User: Extract structured information from my requirements.md file 
      into JSON format with ServiceName, Description, Endpoints, 
      DataModels, and ExternalDependencies
```

**Step 2: Generate microservices (use the other agent)**
```
User: Use this structured requirements JSON to generate C# microservices
```

## Explicit Invocation

If the agent doesn't automatically recognize your request:

### Via Slash Command
Type `/extract-requirements` in the chat (appears in autocomplete once loaded)

### Via Prompt with Keywords
Use clear trigger phrases:
- "Extract requirements" 
- "Parse this requirements file"
- "Convert requirements to JSON"
- "Structure microservice requirements"

### Via Agent Context
Ask the microservice generator agent to first extract requirements:
```
Agent, please:
1. Use extract-requirements skill to parse requirements.md
2. Then use C# Microservice Generator to create services from the result
```

## Skill Status

To verify the skill is properly installed:

1. **Check file location:**
   ```
   .github/
   └── skills/
       └── extract-requirements/
           ├── SKILL.md        (required)
           ├── TEMPLATE.md     (helper)
           └── USAGE.md        (this file)
   ```

2. **Verify YAML frontmatter in SKILL.md:**
   - `name: extract-requirements` (must match folder name)
   - `description:` contains trigger keywords
   - Both enclosed in `---` markers

3. **Test with the agent:**
   - Open a chat
   - Type: "Show available skills" or "What skills do you know?"
   - Look for "extract-requirements" in the response

## Customization

To **modify what the skill extracts**, edit the fields in [SKILL.md](./SKILL.md):

**Current fields:**
- ServiceName
- Description
- Endpoints
- DataModels  
- ExternalDependencies

To add or remove fields:

1. Update the extraction step in SKILL.md
2. Modify the JSON schema examples
3. Update the template in TEMPLATE.md
4. The agent will use the updated skill on next invocation

## Troubleshooting

**Skill not appearing?**
- Confirm file path is exactly: `.github/skills/extract-requirements/SKILL.md`
- Check YAML frontmatter has no syntax errors (colons, dashes)
- Verify `name` field matches folder name
- Restart chat or reload VS Code

**Keywords not matching?**
- Use exact phrases from the `description` field
- Example keywords: "extract", "parse", "structure", "requirements"

**Skill loads but gives wrong results?**
- Requirements file format may differ from template
- Check TEMPLATE.md for supported formats
- Adjust extraction patterns in the skill if needed
