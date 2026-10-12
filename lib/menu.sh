# Termux Launchpad library: menu

cmd_helpme() {
  say ""
  printf '%s\n' "${C_CYAN}TERMUX LAUNCHPAD — COMMAND GUIDE${C_RESET}"
  say "Main menu       launchpad"
  say "Status panel   dashboard"
  say "Help           helpme"
  say "linux / oc     Open Debian and start OpenCode in the current project (if installed)"
  say "debian         Open a Debian shell"
  say "ocinstall      Install OpenCode in Debian"
  say "ocversion      Show OpenCode version in Debian"
  say "omniinstall    Install OmniRoute natively in Termux"
  say "omni           Run OmniRoute in the foreground"
  say "omnibg         Start OmniRoute in the background"
  say "omnistop       Stop the background OmniRoute process started by this tool"
  say "omnistatus     Check OmniRoute at localhost:20128"
  say "omniweb        Open OmniRoute dashboard in Android browser"
  say "omniconnect    Configure OpenCode in Debian to use OmniRoute"
  say "projects       Open the private Termux Projects folder"
  say "sharedprojects Open Android shared storage/Projects"
  say "newproject X   Create a project folder (names can contain spaces)"
  say "project X      Open a project in OpenCode inside Debian"
  say "projectlist    List projects"
  say "backup X       Archive a project into ProjectBackups"
  say "gclone URL     Clone a Git repository into Projects"
  say "gsave MESSAGE  Review, commit and optionally push current repository changes"
  say "gpush / gpull  Push / fast-forward pull"
  say "gstatus       Git status; glog recent commits; gdiff working changes; gremote remotes"
  say "update         Update Termux packages"
  say "dupdate        Update Debian package lists"
  say "dupgrade       Upgrade Debian packages"
  say "dstatus        Show Debian installation status"
  say "lpdoctor       Diagnose common setup problems"
  say "lpupdate       Pull updates when installed from a Git clone"
  say "lpversion      Show Launchpad version"
  say ""
  say "Read the guides in: $INSTALL_DIR/docs/"
}

cmd_launchpad() {
  while true; do
    printf '\n%s\n' "${C_CYAN}TERMUX LAUNCHPAD — BEGINNER MENU${C_RESET}"
    say " 1) Guided first-time setup (base tools)"
    say " 2) Install Debian Linux"
    say " 3) Install OpenCode inside Debian"
    say " 4) Install OmniRoute inside Termux"
    say " 5) Open Debian + OpenCode (linux)"
    say " 6) Open Debian shell"
    say " 7) Start OmniRoute in foreground"
    say " 8) Start OmniRoute in background"
    say " 9) Open project workspace"
    say "10) Create a project"
    say "11) List projects"
    say "12) Dashboard / status"
    say "13) Diagnose setup"
    say "14) Show all shortcuts"
    say "15) Open guides"
    say " 0) Exit"
    read -r -p 'Choose an option: ' choice || return 0
    case "$choice" in
      1) cmd_install_termux;;
      2) cmd_install_debian;;
      3) cmd_ocinstall;;
      4) cmd_omniinstall;;
      5) cmd_linux;;
      6) cmd_debian;;
      7) cmd_omni;;
      8) cmd_omnibg;;
      9) cmd_projects;;
      10) read -r -p 'Project name: ' pname; cmd_newproject "$pname";;
      11) cmd_projectlist;;
      12) cmd_dashboard;;
      13) cmd_lpdoctor;;
      14) cmd_helpme;;
      15) say "Guides are in: $INSTALL_DIR/docs"; if has termux-open; then termux-open "$INSTALL_DIR/docs/START_HERE.md" >/dev/null 2>&1 || true; fi;;
      0|q|Q|exit) return 0;;
      *) warn "Please enter a menu number from 0 to 15.";;
    esac
    printf '\n'
    if [ -t 0 ]; then read -r -p 'Press Enter to return to the menu...' _ || true; fi
  done
}

