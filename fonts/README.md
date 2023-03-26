## codicon

我这里保存的是修改版本，原仓库 [microsoft/vscode-codicons](https://github.com/microsoft/vscode-codicons)

原版字体文件下载链接: <https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.ttf>

原版的字体文件在我的终端（kitty）上显示位置偏上，根据 [issue 94](https://github.com/microsoft/vscode-codicons/issues/94), 找到解决方法

1. 克隆仓库到本地，并进入
    ```shell
    git clone https://github.com/microsoft/vscode-codicons.git
    cd vscode-codicons
    ```
2. 替换viewBox

    如果使用的是macOS自带的`sed`，使用下面的命令修改
    ```bash
    sed -i '' -r 's|viewBox="0 -?[0-9]* ([0-9]* [0-9]*)"|viewBox="0 -3 \1"|g' src/icons/*.svg
    ```

剩下的就是按 [vscode-codicons](https://github.com/microsoft/vscode-codicons) 说的安装依赖，然后执行就好了

```bash
npm install
npm run build
```


## codicon 字符集

打印所有字符

```python
for i, codepoint in enumerate(range(int('ea60', 16), int('ec0e', 16) + 1)):
    print(f"| {chr(codepoint)}  | {hex(codepoint).replace('0x', 'U+').upper()} ", end='')
    if (i + 1) % 6 == 0:
        print('|')
print('|')
```

|icon|  code  | desc                         |icon|  code  | desc                                    |
|:--:|  :--:  | :---                         |:--:|  :--:  | :---                                    |
|   | U+EA60 | add                          |   | U+EA61 | lightbulb                               |
|   | U+EA62 | repo                         |   | U+EA63 | repo-forked                             |
|   | U+EA64 | git-pull-request             |   | U+EA65 | record-keys                             |
|   | U+EA66 | tag                          |   | U+EA67 | person                                  |
|   | U+EA68 | source-control               |   | U+EA69 | mirror                                  |
|   | U+EA6A | star-empty                   |   | U+EA6B | comment                                 |
|   | U+EA6C | warning                      |   | U+EA6D | search                                  |
|   | U+EA6E | sign-out                     |   | U+EA6F | sign-in                                 |
|   | U+EA70 | eye                          |   | U+EA71 | circle-filled                           |
|   | U+EA72 | primitive-square             |   | U+EA73 | edit                                    |
|   | U+EA74 | info                         |   | U+EA75 | lock                                    |
|   | U+EA76 | close                        |   | U+EA77 | sync                                    |
|   | U+EA78 | desktop-download             |   | U+EA79 | beaker                                  |
|   | U+EA7A | vm                           |   | U+EA7B | file                                    |
|   | U+EA7C | ellipsis                     |   | U+EA7D | reply                                   |
|   | U+EA7E | organization                 |   | U+EA7F | new-file                                |
|   | U+EA80 | new-folder                   |   | U+EA81 | trash                                   |
|   | U+EA82 | history                      |   | U+EA83 | folder                                  |
|   | U+EA84 | github                       |   | U+EA85 | terminal                                |
|   | U+EA86 | symbol-event                 |   | U+EA87 | error                                   |
|   | U+EA88 | symbol-variable              |   | U+EA8A | symbol-array                            |
|   | U+EA8B | symbol-namespace             |   | U+EA8C | symbol-method                           |
|   | U+EA8F | symbol-boolean               |   | U+EA90 | symbol-numeric                          |
|   | U+EA91 | symbol-structure             |   | U+EA92 | symbol-parameter                        |
|   | U+EA93 | symbol-key                   |   | U+EA94 | go-to-file                              |
|   | U+EA95 | symbol-enum                  |   | U+EA96 | symbol-ruler                            |
|   | U+EA97 | activate-breakpoints         |   | U+EA98 | archive                                 |
|   | U+EA99 | arrow-both                   |   | U+EA9A | arrow-down                              |
|   | U+EA9B | arrow-left                   |   | U+EA9C | arrow-right                             |
|   | U+EA9D | arrow-small-down             |   | U+EA9E | arrow-small-left                        |
|   | U+EA9F | arrow-small-right            |   | U+EAA0 | arrow-small-up                          |
|   | U+EAA1 | arrow-up                     |   | U+EAA2 | bell                                    |
|   | U+EAA3 | bold                         |   | U+EAA4 | book                                    |
|   | U+EAA5 | bookmark                     |   | U+EAA6 | debug-breakpoint-conditional-unverified |
|   | U+EAA7 | debug-breakpoint-conditional |   | U+EAA8 | debug-breakpoint-data-unverified        |
|   | U+EAA9 | debug-breakpoint-data        |   | U+EAAA | debug-breakpoint-log-unverified         |
|   | U+EAAB | debug-breakpoint-log         |   | U+EAAC | briefcase                               |
|   | U+EAAD | broadcast                    |   | U+EAAE | browser                                 |
|   | U+EAAF | bug                          |   | U+EAB0 | calendar                                |
|   | U+EAB1 | case-sensitive               |   | U+EAB2 | check                                   |
|   | U+EAB3 | checklist                    |   | U+EAB4 | chevron-down                            |
|   | U+EAB5 | chevron-left                 |   | U+EAB6 | chevron-right                           |
|   | U+EAB7 | chevron-up                   |   | U+EAB8 | chrome-close                            |
|   | U+EAB9 | chrome-maximize              |   | U+EABA | chrome-minimize                         |
|   | U+EABB | chrome-restore               |   | U+EABC | circle                                  |
|   | U+EABD | circle-slash                 |   | U+EABE | circuit-board                           |
|   | U+EABF | clear-all                    |   | U+EAC0 | clippy                                  |
|   | U+EAC1 | close-all                    |   | U+EAC2 | cloud-download                          |
|   | U+EAC3 | cloud-upload                 |   | U+EAC4 | code                                    |
|   | U+EAC5 | collapse-all                 |   | U+EAC6 | color-mode                              |
|   | U+EAC7 | comment-discussion           |   | U+EAC9 | credit-card                             |
|   | U+EACC | dash                         |   | U+EACD | dashboard                               |
|   | U+EACE | database                     |   | U+EACF | debug-continue                          |
|   | U+EAD0 | debug-disconnect             |   | U+EAD1 | debug-pause                             |
|   | U+EAD2 | debug-restart                |   | U+EAD3 | debug-start                             |
|   | U+EAD4 | debug-step-into              |   | U+EAD5 | debug-step-out                          |
|   | U+EAD6 | debug-step-over              |   | U+EAD7 | debug-stop                              |
|   | U+EAD8 | debug                        |   | U+EAD9 | device-camera-video                     |
|   | U+EADA | device-camera                |   | U+EADB | device-mobile                           |
|   | U+EADC | diff-added                   |   | U+EADD | diff-ignored                            |
|   | U+EADE | diff-modified                |   | U+EADF | diff-removed                            |
|   | U+EAE0 | diff-renamed                 |   | U+EAE1 | diff                                    |
|   | U+EAE2 | discard                      |   | U+EAE3 | editor-layout                           |
|   | U+EAE4 | empty-window                 |   | U+EAE5 | exclude                                 |
|   | U+EAE6 | extensions                   |   | U+EAE7 | eye-closed                              |
|   | U+EAE8 | file-binary                  |   | U+EAE9 | file-code                               |
|   | U+EAEA | file-media                   |   | U+EAEB | file-pdf                                |
|   | U+EAEC | file-submodule               |   | U+EAED | file-symlink-directory                  |
|   | U+EAEE | file-symlink-file            |   | U+EAEF | file-zip                                |
|   | U+EAF0 | files                        |   | U+EAF1 | filter                                  |
|   | U+EAF2 | flame                        |   | U+EAF3 | fold-down                               |
|   | U+EAF4 | fold-up                      |   | U+EAF5 | fold                                    |
|   | U+EAF6 | folder-active                |   | U+EAF7 | folder-opened                           |
|   | U+EAF8 | gear                         |   | U+EAF9 | gift                                    |
|   | U+EAFA | gist-secret                  |   | U+EAFB | file-code                               |
|   | U+EAFC | git-commit                   |   | U+EAFD | git-compare                             |
|   | U+EAFE | git-merge                    |   | U+EAFF | github-action                           |
|   | U+EB00 | github-alt                   |   | U+EB01 | globe                                   |
|   | U+EB02 | grabber                      |   | U+EB03 | graph                                   |
|   | U+EB04 | gripper                      |   | U+EB05 | heart                                   |
|   | U+EB06 | home                         |   | U+EB07 | horizontal-rule                         |
|   | U+EB08 | hubot                        |   | U+EB09 | inbox                                   |
|   | U+EB0B | issue-reopened               |   | U+EB0C | issues                                  |
|   | U+EB0D | italic                       |   | U+EB0E | jersey                                  |
|   | U+EB0F | json                         |   | U+EB10 | kebab-vertical                          |
|   | U+EB11 | key                          |   | U+EB12 | law                                     |
|   | U+EB13 | lightbulb-autofix            |   | U+EB14 | link-external                           |
|   | U+EB15 | link                         |   | U+EB16 | list-ordered                            |
|   | U+EB17 | list-unordered               |   | U+EB18 | live-share                              |
|   | U+EB19 | loading                      |   | U+EB1A | location                                |
|   | U+EB1B | mail-read                    |   | U+EB1C | mail                                    |
|   | U+EB1D | markdown                     |   | U+EB1E | megaphone                               |
|   | U+EB1F | mention                      |   | U+EB20 | milestone                               |
|   | U+EB21 | mortar-board                 |   | U+EB22 | move                                    |
|   | U+EB23 | multiple-windows             |   | U+EB24 | mute                                    |
|   | U+EB25 | no-newline                   |   | U+EB26 | note                                    |
|   | U+EB27 | octoface                     |   | U+EB28 | open-preview                            |
|   | U+EB29 | package                      |   | U+EB2A | paintcan                                |
|   | U+EB2B | pin                          |   | U+EB2C | play                                    |
|   | U+EB2D | plug                         |   | U+EB2E | preserve-case                           |
|   | U+EB2F | preview                      |   | U+EB30 | project                                 |
|   | U+EB31 | pulse                        |   | U+EB32 | question                                |
|   | U+EB33 | quote                        |   | U+EB34 | radio-tower                             |
|   | U+EB35 | reactions                    |   | U+EB36 | references                              |
|   | U+EB37 | refresh                      |   | U+EB38 | regex                                   |
|   | U+EB39 | remote-explorer              |   | U+EB3A | remote                                  |
|   | U+EB3B | remove                       |   | U+EB3C | replace-all                             |
|   | U+EB3D | replace                      |   | U+EB3E | repo-clone                              |
|   | U+EB3F | repo-force-push              |   | U+EB40 | repo-pull                               |
|   | U+EB41 | repo-push                    |   | U+EB42 | report                                  |
|   | U+EB43 | request-changes              |   | U+EB44 | rocket                                  |
|   | U+EB45 | root-folder-opened           |   | U+EB46 | root-folder                             |
|   | U+EB47 | rss                          |   | U+EB48 | ruby                                    |
|   | U+EB49 | save-all                     |   | U+EB4A | save-as                                 |
|   | U+EB4B | save                         |   | U+EB4C | screen-full                             |
|   | U+EB4D | screen-normal                |   | U+EB4E | search-stop                             |
|   | U+EB50 | server                       |   | U+EB51 | settings-gear                           |
|   | U+EB52 | settings                     |   | U+EB53 | shield                                  |
|   | U+EB54 | smiley                       |   | U+EB55 | sort-precedence                         |
|   | U+EB56 | split-horizontal             |   | U+EB57 | split-vertical                          |
|   | U+EB58 | squirrel                     |   | U+EB59 | star-full                               |
|   | U+EB5A | star-half                    |   | U+EB5B | symbol-class                            |
|   | U+EB5C | symbol-color                 |   | U+EB5D | symbol-constant                         |
|   | U+EB5E | symbol-enum-member           |   | U+EB5F | symbol-field                            |
|   | U+EB60 | symbol-file                  |   | U+EB61 | symbol-interface                        |
|   | U+EB62 | symbol-keyword               |   | U+EB63 | symbol-misc                             |
|   | U+EB64 | symbol-operator              |   | U+EB65 | symbol-property                         |
|   | U+EB66 | symbol-snippet               |   | U+EB67 | tasklist                                |
|   | U+EB68 | telescope                    |   | U+EB69 | text-size                               |
|   | U+EB6A | three-bars                   |   | U+EB6B | thumbsdown                              |
|   | U+EB6C | thumbsup                     |   | U+EB6D | tools                                   |
|   | U+EB6E | triangle-down                |   | U+EB6F | triangle-left                           |
|   | U+EB70 | triangle-right               |   | U+EB71 | triangle-up                             |
|   | U+EB72 | twitter                      |   | U+EB73 | unfold                                  |
|   | U+EB74 | unlock                       |   | U+EB75 | unmute                                  |
|   | U+EB76 | unverified                   |   | U+EB77 | verified                                |
|   | U+EB78 | versions                     |   | U+EB79 | vm-active                               |
|   | U+EB7A | vm-outline                   |   | U+EB7B | vm-running                              |
|   | U+EB7C | watch                        |   | U+EB7D | whitespace                              |
|   | U+EB7E | whole-word                   |   | U+EB7F | window                                  |
|   | U+EB80 | word-wrap                    |   | U+EB81 | zoom-in                                 |
|   | U+EB82 | zoom-out                     |   | U+EB83 | list-filter                             |
|   | U+EB84 | list-flat                    |   | U+EB85 | list-selection                          |
|   | U+EB86 | list-tree                    |   | U+EB87 | debug-breakpoint-function-unverified    |
|   | U+EB88 | debug-breakpoint-function    |   | U+EB89 | debug-stackframe-active                 |
|   | U+EB8A | circle-small-filled          |   | U+EB8B | debug-stackframe                        |
|   | U+EB8C | debug-breakpoint-unsupported |   | U+EB8D | symbol-string                           |
|   | U+EB8E | debug-reverse-continue       |   | U+EB8F | debug-step-back                         |
|   | U+EB90 | debug-restart-frame          |   | U+EB91 | debug-alt                               |
|   | U+EB92 | call-incoming                |   | U+EB93 | call-outgoing                           |
|   | U+EB94 | menu                         |   | U+EB95 | expand-all                              |
|   | U+EB96 | feedback                     |   | U+EB97 | group-by-ref-type                       |
|   | U+EB98 | ungroup-by-ref-type          |   | U+EB99 | account                                 |
|   | U+EB9A | bell-dot                     |   | U+EB9B | debug-console                           |
|   | U+EB9C | library                      |   | U+EB9D | output                                  |
|   | U+EB9E | run-all                      |   | U+EB9F | sync-ignored                            |
|   | U+EBA0 | pinned                       |   | U+EBA1 | github-inverted                         |
|   | U+EBA2 | server-process               |   | U+EBA3 | server-environment                      |
|   | U+EBA4 | pass                         |   | U+EBA5 | stop-circle                             |
|   | U+EBA6 | play-circle                  |   | U+EBA7 | record                                  |
|   | U+EBA8 | debug-alt-small              |   | U+EBA9 | vm-connect                              |
|   | U+EBAA | cloud                        |   | U+EBAB | merge                                   |
|   | U+EBAC | export                       |   | U+EBAD | graph-left                              |
|   | U+EBAE | magnet                       |   | U+EBAF | notebook                                |
|   | U+EBB0 | redo                         |   | U+EBB1 | check-all                               |
|   | U+EBB2 | pinned-dirty                 |   | U+EBB3 | pass-filled                             |
|   | U+EBB4 | circle-large-filled          |   | U+EBB5 | circle-large                            |
|   | U+EBB6 | combine                      |   | U+EBB7 | table                                   |
|   | U+EBB8 | variable-group               |   | U+EBB9 | type-hierarchy                          |
|   | U+EBBA | type-hierarchy-sub           |   | U+EBBB | type-hierarchy-super                    |
|   | U+EBBC | git-pull-request-create      |   | U+EBBD | run-above                               |
|   | U+EBBE | run-below                    |   | U+EBBF | notebook-template                       |
|   | U+EBC0 | debug-rerun                  |   | U+EBC1 | workspace-trusted                       |
|   | U+EBC2 | workspace-untrusted          |   | U+EBC3 | workspace-unknown                       |
|   | U+EBC4 | terminal-cmd                 |   | U+EBC5 | terminal-debian                         |
|   | U+EBC6 | terminal-linux               |   | U+EBC7 | terminal-powershell                     |
|   | U+EBC8 | terminal-tmux                |   | U+EBC9 | terminal-ubuntu                         |
|   | U+EBCA | terminal-bash                |   | U+EBCB | arrow-swap                              |
|   | U+EBCC | copy                         |   | U+EBCD | person-add                              |
|   | U+EBCE | filter-filled                |   | U+EBCF | wand                                    |
|   | U+EBD0 | debug-line-by-line           |   | U+EBD1 | inspect                                 |
|   | U+EBD2 | layers                       |   | U+EBD3 | layers-dot                              |
|   | U+EBD4 | layers-active                |   | U+EBD5 | compass                                 |
|   | U+EBD6 | compass-dot                  |   | U+EBD7 | compass-active                          |
|   | U+EBD8 | azure                        |   | U+EBD9 | issue-draft                             |
|   | U+EBDA | git-pull-request-closed      |   | U+EBDB | git-pull-request-draft                  |
|   | U+EBDC | debug-all                    |   | U+EBDD | debug-coverage                          |
|   | U+EBDE | run-errors                   |   | U+EBDF | folder-library                          |
|   | U+EBE0 | debug-continue-small         |   | U+EBE1 | beaker-stop                             |
|   | U+EBE2 | graph-line                   |   | U+EBE3 | graph-scatter                           |
|   | U+EBE4 | pie-chart                    |   | U+EBE5 | bracket-dot                             |
|   | U+EBE6 | bracket-error                |   | U+EBE7 | lock-small                              |
|   | U+EBE8 | azure-devops                 |   | U+EBE9 | verified-filled                         |
|   | U+EBEA | newline                      |   | U+EBEB | layout                                  |
|   | U+EBEC | layout-activitybar-left      |   | U+EBED | layout-activitybar-right                |
|   | U+EBEE | layout-panel-left            |   | U+EBEF | layout-panel-center                     |
|   | U+EBF0 | layout-panel-justify         |   | U+EBF1 | layout-panel-right                      |
|   | U+EBF2 | layout-panel                 |   | U+EBF3 | layout-sidebar-left                     |
|   | U+EBF4 | layout-sidebar-right         |   | U+EBF5 | layout-statusbar                        |
|   | U+EBF6 | layout-menubar               |   | U+EBF7 | layout-centered                         |
|   | U+EBF8 | target                       |   | U+EBF9 | indent                                  |
|   | U+EBFA | record-small                 |   | U+EBFB | error-small                             |
|   | U+EBFC | arrow-circle-down            |   | U+EBFD | arrow-circle-left                       |
|   | U+EBFE | arrow-circle-right           |   | U+EBFF | arrow-circle-up                         |
|   | U+EC00 | layout-sidebar-right-off     |   | U+EC01 | layout-panel-off                        |
|   | U+EC02 | layout-sidebar-left-off      |   | U+EC03 | blank                                   |
|   | U+EC04 | heart-filled                 |   | U+EC05 | map                                     |
|   | U+EC06 | map-filled                   |   | U+EC07 | circle-small                            |
|   | U+EC08 | bell-slash                   |   | U+EC09 | bell-slash-dot                          |
|   | U+EC0A | comment-unresolved           |   | U+EC0B | git-pull-request-go-to-changes          |
|   | U+EC0C | git-pull-request-new-changes |   | U+EC0D | search-fuzzy                            |
|   | U+EC0E | comment-draft                |   | U+EC0F | send                                    |
|   | U+EC10 | sparkle                      |   | U+EC11 | insert                                  |
