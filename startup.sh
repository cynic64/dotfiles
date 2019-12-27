killall compton
compton &
xset r rate 192 32
# rebind caps to control
setxkbmap -layout us -option ctrl:nocaps
# reduce mouse speed
xinput --set-prop 10 'libinput Accel Speed' -1.0
