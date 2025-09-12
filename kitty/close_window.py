from kittens.tui.handler import result_handler
from kitty.boss import Boss
from kitty.window import Window


def main(args: list[str]) -> str:
    return ''


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss) -> None:
    window: Window | None = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    cmd = window.child.foreground_cmdline[0]
    if cmd in ['tmux', 'nvim', 'ssh', '/usr/bin/ssh']:
        _ = window.send_key('alt+ŵ')
    else:
        # boss.close_window_with_confirmation()
        window.close()
