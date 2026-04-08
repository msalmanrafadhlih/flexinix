{ pkgs, ... }:

{
 services = {
	libinput = {
	    enable = true;
	    touchpad = {
	        tapping = true;
	        naturalScrolling = true;
	        disableWhileTyping = true;
	        sendEventsMode = "disabled-on-external-mouse";
	    };
	};

    udev = {
        enable = true;
        extraRules = let
		    checkMice = pkgs.writeScript "check-mice" ''
		    #!${pkgs.bash}/bin/bash

		    # Check mice
		    internal=(
		      'Raydium Corporation Raydium Touch System'
		      'Synaptics TM3289-021'
		      'TPPS/2 Elan TrackPoint'
		    )

		    inhibitTrackpad=0

		    for nameFile in /sys/class/input/mouse*/device/name; do
		      name=$(cat "$nameFile")
		      found=
		      for (( i=0; i < ''${#internal[@]}; i += 1 )); do
		        if [[ ''${internal[$i]} == $name ]]; then
		          found=yes
		          break
		        fi
		      done
		      if [[ ! $found ]]; then
		        # There is at least one external mouse connected
		        inhibitTrackpad=1
		        break
		      fi
		    done

		    echo "$inhibitTrackpad" > /sys/class/input/mouse1/device/inhibited
		  '';
		in ''
		  # Detect addition or removal of mouse devices, then enable or disable trackpad when external mouse is attached
		  SUBSYSTEM=="input", DEVPATH=="*/input/*/mouse*", RUN+="${checkMice}"
		'';
    };
  };
}

