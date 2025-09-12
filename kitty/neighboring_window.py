from typing import Literal, cast

from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: list[str]) -> str:
    return ''


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss) -> None:
    direction = cast(Literal['left', 'right', 'top', 'bottom'], args[1])
    key_mapping = args[2]
    window = boss.window_id_map.get(target_window_id)
    if window is None or boss.active_tab is None:
        return
    cmd = window.child.foreground_cmdline[0]
    if cmd in ['tmux', 'nvim', 'ssh', '/usr/bin/ssh']:
        _ = window.send_key(key_mapping)
    else:
        boss.active_tab.neighboring_window(direction)
