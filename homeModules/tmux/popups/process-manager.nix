{
  programs.tmux.extraConfig = ''
    

  set-option -g command-alias[111] 'signal-kill=display-menu -T "#[align=centre] 🔪 Force Kill " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGKILL \" -E \"rip -s KILL --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGKILL \" -E \"rip -s KILL\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGKILL \" -E \"rip -s KILL --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGKILL \" -E \"rip -s KILL --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[112] 'hangup=display-menu -T "#[align=centre] 🔪 Reset Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGHUP \" -E \"rip -s HUP --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGHUP \" -E \"rip -s HUP\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGHUP \" -E \"rip -s HUP --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGHUP \" -E \"rip -s HUP --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[113] 'interrupt=display-menu -T "#[align=centre] 🔪 Interrupt ctrl + c " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNINT \" -E \"rip -s INT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNINT \" -E \"rip -s INT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNINT \" -E \"rip -s INT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNINT \" -E \"rip -s INT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[114] 'signal-quit=display-menu -T "#[align=centre] 🔪 QUIT the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNQUIT \" -E \"rip -s QUIT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNQUIT \" -E \"rip -s QUIT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNQUIT \" -E \"rip -s QUIT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNQUIT \" -E \"rip -s QUIT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[115] 'usr1=display-menu -T "#[align=centre] 🔪 USR1 the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"rip -s USR1 --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"rip -s USR1\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"rip -s USR1 --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"rip -s USR1 --sort name\"" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[116] 'usr2=display-menu -T "#[align=centre] 🔪 USR2 the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"rip -s USR2 --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"rip -s USR2\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"rip -s USR2 --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"rip -s USR2 --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[117] 'terminate=display-menu -T "#[align=centre] 🔪 Soft Kill " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNTERM \" -E \"rip -s TERM --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNTERM \" -E \"rip -s TERM\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNTERM \" -E \"rip -s TERM --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNTERM \" -E \"rip -s TERM --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[118] 'signal-continue=display-menu -T "#[align=centre] 🔪 CONT the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNCONT \" -E \"rip -s CONT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNCONT \" -E \"rip -s CONT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNCONT \" -E \"rip -s CONT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNCONT \" -E \"rip -s CONT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[119] 'signal-stop=display-menu -T "#[align=centre] 🔪 STOP the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNSTOP \" -E \"rip -s STOP --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNSTOP \" -E \"rip -s STOP\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNSTOP \" -E \"rip -s STOP --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNSTOP \" -E \"rip -s STOP --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'      
  '';
}
