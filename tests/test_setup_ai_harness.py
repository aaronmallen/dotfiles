import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / 'home/.chezmoiscripts/run_after_setup-ai-harness.zsh.tmpl'


def render(template):
    return subprocess.run(['chezmoi', '--source', str(ROOT), 'execute-template', template], capture_output=True, text=True, check=True).stdout

FAKE_CLI = '''#!/usr/bin/env python3
import json, os, pathlib, sys
root = pathlib.Path(os.environ['XDG_CONFIG_HOME'])
state_file = root / 'state.json'
state = json.loads(state_file.read_text()) if state_file.exists() else {'claude': {}, 'codex': {}, 'claude_plugin': False, 'market': False, 'codex_plugin': False, 'changes': 0}
args = [pathlib.Path(sys.argv[0]).name, *sys.argv[1:]]
if args[:4] == ['claude', 'mcp', 'add', '--scope']:
    if '--' in args:
        i = args.index('--'); state['claude'][args[i - 1]] = {'type': 'stdio', 'command': args[i + 1], 'args': args[i + 2:], 'env': {}}
    else:
        rest = args[8:]; server = {'type': 'http', 'url': rest[0]}
        if rest[1:2] == ['--header']: server['headers'] = dict([rest[2].split(': ', 1)])
        state['claude'][args[7]] = server
    (root / 'claude/.claude.json').write_text(json.dumps({'mcpServers': state['claude']}))
elif args == ['claude', 'plugin', 'list', '--json']:
    print(json.dumps([{'id': 'ponytail@ponytail', 'scope': 'user'}] if state['claude_plugin'] else []))
elif args[:3] == ['claude', 'plugin', 'install']:
    state['claude_plugin'] = True
elif args == ['codex', 'mcp', 'list', '--json']:
    print(json.dumps([{'name': n, 'transport': t} for n, t in state['codex'].items()]))
elif args[:3] == ['codex', 'mcp', 'add']:
    if '--' in args:
        i = args.index('--'); state['codex'][args[3]] = {'type': 'stdio', 'command': args[i + 1], 'args': args[i + 2:]}
    else:
        rest = args[4:]; state['codex'][args[3]] = {'type': 'streamable_http', 'url': rest[1], 'bearer_token_env_var': rest[3] if len(rest) > 3 else None}
elif args == ['codex', 'plugin', 'marketplace', 'list', '--json']:
    source = {'source': 'https://github.com/DietrichGebert/ponytail.git'}
    print(json.dumps({'marketplaces': [{'name': 'ponytail', 'root': str(root / 'market'), 'marketplaceSource': source}] if state['market'] else []}))
elif args[:4] == ['codex', 'plugin', 'marketplace', 'add']:
    state['market'] = True; (root / 'market/.agents/plugins').mkdir(parents=True); (root / 'market/.agents/plugins/marketplace.json').touch()
elif args == ['codex', 'plugin', 'list', '--marketplace', 'ponytail', '--json']:
    print(json.dumps({'installed': [{'pluginId': 'ponytail@ponytail', 'enabled': True}] if state['codex_plugin'] else []}))
elif args[:3] == ['codex', 'plugin', 'add']:
    state['codex_plugin'] = True
else:
    raise SystemExit(f'Unexpected command: {args}')
if 'add' in args or 'install' in args: state['changes'] += 1
state_file.write_text(json.dumps(state))
if args[:4] == ['codex', 'mcp', 'add', 'gmail']:
    raise SystemExit('Error: Dynamic client registration not supported')
'''


class SetupTest(unittest.TestCase):
    def test_setup_is_idempotent_and_rejects_conflicts(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'claude').mkdir()
            (root / 'bin').mkdir()
            script = root / 'setup.zsh'
            script.write_text(render(TEMPLATE.read_text()))
            for name in ('claude', 'codex'):
                executable = root / 'bin' / name
                executable.write_text(FAKE_CLI)
                executable.chmod(0o755)
            env = dict(os.environ, XDG_CONFIG_HOME=directory, CLAUDE_CONFIG_DIR=str(root / 'claude'), PATH=f'{root / "bin"}:{os.environ["PATH"]}')
            subprocess.run(['zsh', str(script)], env=env, check=True)
            state_file = root / 'state.json'
            state = json.loads(state_file.read_text())
            self.assertEqual(state['claude']['github']['headers'], {'Authorization': 'Bearer ${GITHUB_MCP_TOKEN}'})
            self.assertEqual(state['codex']['github']['bearer_token_env_var'], 'GITHUB_MCP_TOKEN')
            count = int(render('{{ len .ai.mcp_servers }}'))
            self.assertEqual((len(state['claude']), len(state['codex']), state['changes']), (count, count, 2 * count + 3))
            subprocess.run(['zsh', str(script)], env=env, check=True)
            self.assertEqual(json.loads(state_file.read_text())['changes'], 2 * count + 3)
            for name, transport in (('gmail', {'type': 'streamable_http', 'url': 'https://example.invalid/mcp', 'bearer_token_env_var': None}),
                                    ('github', {'type': 'streamable_http', 'url': 'https://api.githubcopilot.com/mcp/', 'bearer_token_env_var': None}),
                                    ('serena', {'type': 'stdio', 'command': 'serena', 'args': []})):
                conflict = json.loads(json.dumps(state))
                conflict['codex'][name] = transport
                state_file.write_text(json.dumps(conflict))
                result = subprocess.run(['zsh', str(script)], env=env, capture_output=True, text=True)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn(f'Codex MCP server {name} has a different configuration', result.stderr)


if __name__ == '__main__':
    unittest.main()
