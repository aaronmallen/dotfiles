import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / 'home/.chezmoiscripts/run_after_setup-ai-harness.zsh.tmpl'
OPENCODE = ROOT / 'home/private_dot_config/private_opencode/private_opencode.json.tmpl'
PROFILE_SERVERS = {
    'datadog': 'work',
    'everflow': 'work',
    'linear-aaronmallen': 'personal',
    'linear-complish': 'personal',
    'slack': 'work',
}


def render(template, profile='work'):
    command = ['chezmoi', '--source', str(ROOT), '--override-data', json.dumps({'profile': profile}), 'execute-template', template]
    return subprocess.run(command, capture_output=True, text=True, check=True).stdout

FAKE_CLI = '''#!/usr/bin/env python3
import json, os, pathlib, sys, tomllib
root = pathlib.Path(os.environ['XDG_CONFIG_HOME'])
state_file = root / 'state.json'
state = json.loads(state_file.read_text()) if state_file.exists() else {'claude': {}, 'codex': {}, 'claude_plugin': False, 'market': False, 'codex_plugin': False, 'changes': 0}
args = [pathlib.Path(sys.argv[0]).name, *sys.argv[1:]]
if args[:4] == ['claude', 'mcp', 'add', '--scope']:
    if '--' in args:
        i = args.index('--'); state['claude'][args[i - 1]] = {'type': 'stdio', 'command': args[i + 1], 'args': args[i + 2:], 'env': {}}
    else:
        rest = args[8:]; server = {'type': 'http', 'url': rest[0]}
        options = dict(zip(rest[1::2], rest[2::2]))
        if '--header' in options: server['headers'] = dict([options['--header'].split(': ', 1)])
        if '--client-id' in options: server['oauth'] = {'clientId': options['--client-id'], 'callbackPort': int(options['--callback-port'])}
        state['claude'][args[7]] = server
    (root / 'claude/.claude.json').write_text(json.dumps({'mcpServers': state['claude']}))
elif args == ['claude', 'plugin', 'list', '--json']:
    print(json.dumps([{'id': 'ponytail@ponytail', 'scope': 'user'}] if state['claude_plugin'] else []))
elif args[:3] == ['claude', 'plugin', 'install']:
    state['claude_plugin'] = True
elif args == ['codex', 'mcp', 'list', '--json']:
    config = pathlib.Path(os.environ['CODEX_HOME'], 'config.toml')
    headers = tomllib.loads(config.read_text()).get('mcp_servers', {}) if config.exists() else {}
    print(json.dumps([{'name': n, 'transport': {**t, 'env_http_headers': headers.get(n, {}).get('env_http_headers')}} for n, t in state['codex'].items()]))
elif args[:3] == ['codex', 'mcp', 'add']:
    if '--' in args:
        i = args.index('--'); state['codex'][args[3]] = {'type': 'stdio', 'command': args[i + 1], 'args': args[i + 2:]}
    else:
        options = dict(zip(args[4::2], args[5::2]))
        state['codex'][args[3]] = {'type': 'streamable_http', 'url': options['--url'], 'bearer_token_env_var': options.get('--bearer-token-env-var')}
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
            env = dict(os.environ, XDG_CONFIG_HOME=directory, CLAUDE_CONFIG_DIR=str(root / 'claude'), CODEX_HOME=directory, PATH=f'{root / "bin"}:{os.environ["PATH"]}')
            subprocess.run(['zsh', str(script)], env=env, check=True)
            state_file = root / 'state.json'
            state = json.loads(state_file.read_text())
            self.assertEqual(state['claude']['github']['headers'], {'Authorization': 'Bearer ${GITHUB_MCP_TOKEN}'})
            self.assertEqual(state['codex']['github']['bearer_token_env_var'], 'GITHUB_MCP_TOKEN')
            self.assertEqual(state['claude']['everflow']['headers'], {'X-Api-Key': '${EVERFLOW_API_KEY}'})
            self.assertIn('"X-Api-Key" = "EVERFLOW_API_KEY"', (root / 'config.toml').read_text())
            count = int(render('{{ len .ai.mcp_servers }}')) - sum(profile != 'work' for profile in PROFILE_SERVERS.values())
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

    def test_profile_servers_only_render_for_their_profile(self):
        for profile in ('work', 'personal'):
            servers = set(json.loads(render(OPENCODE.read_text(), profile))['mcp']['servers'])
            script = render(TEMPLATE.read_text(), profile)
            for name, owner in PROFILE_SERVERS.items():
                self.assertEqual(name in servers, profile == owner)
                self.assertEqual(f"codex_server '{name}'" in script, profile == owner)
                self.assertEqual(f"claude_server '{name}'" in script, profile == owner)


if __name__ == '__main__':
    unittest.main()
