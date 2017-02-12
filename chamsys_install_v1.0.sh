#/bin/bash
################################################
## Installation script for Chamsys MagicQ     ##
## Based on the works of Jan Lange &          ##
## The Ducks - Sound & Lightservice           ##
## V1.0 - 02/2017							  ##
################################################


# Homedir of the User after installation. e.g. "chamsys"
HOME_DIR=/home/chamsys


# ------------------------------------------------------------
echo "###############################"
echo "# ChamSys Installer v1.0	    #"
echo "# Matthieu Gaillet		    #"
echo "# based on Jan Lange's script #"
echo "# for Debian 8.0              #"
echo "###############################"



echo "Adding Chamsys's repo"
wget http://repo.magicq.co.uk/magicq.co.uk.gpg -qO - | sudo apt-key add -
echo 'deb http://repo.magicq.co.uk/magicq/ magicq main' >> /etc/apt/sources.list

echo "Adding Mozilla's repo"
wget mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb
dpkg -i pkg-mozilla-archive-keyring_1.1_all.deb
rm mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb
echo 'deb http://mozilla.debian.net/ jessie-backports firefox-release' >> /etc/apt/sources.list

echo
echo "Update Packagelist"
apt-get update
apt-get --auto-remove upgrade -y
apt-get autoclean

echo "Install Systemtools"
apt-get install vim lynx less openssh-server ntp -y

echo 
echo "Set Environment"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

echo
echo "Install Xorg Window System"
apt-get install xserver-xorg xinit mesa-utils xinput x11-xserver-utils xcompmgr -y
# Optional. Funktioniert nicht unter Debian Testing Wheezy und meiner Radeon nicht.
#apt-get install firmware-linux-nonfree firmware-linux-free -y

echo
echo "Install Openbox and PCManFM"
apt-get install openbox pcmanfm tint2 lxappearance lxinput lxterminal lxtask lxrandr -y

echo
echo "Install X11 apps"
apt-get install qpdfview gxmessage xdotool scite firefox -y 

echo
echo "Install and configure usbmount"
apt-get install usbmount -y

echo "Install MagicQ"
apt-get install magicq-beta -y

echo
echo "Shortening Grub loader wait time"
sed -i "s/set timeout=.*/set timeout=0/g" /boot/grub/grub.cfg

echo
echo "Copy Desktop Icons"
mkdir -p /root/Desktop/
cp /usr/share/applications/pcmanfm.desktop /root/Desktop/
cp /usr/share/applications/lxterminal.desktop /root/Desktop/
cp /usr/share/applications/qpdfview.desktop /root/Desktop/
cp /usr/share/applications/lxtask.desktop /root/Desktop/
cp /usr/share/applications/lxrandr.desktop /root/Desktop/
cp /usr/share/applications/magicq.desktop /root/Desktop/
cp /usr/share/applications/firefox.desktop /root/Desktop/

echo
echo "Configure Auto-Login on tty2"
apt-get install rungetty -y
mkdir -p "/etc/systemd/system/getty@tty1.service.d"
echo "[Service]" > "/etc/systemd/system/getty@tty1.service.d/autologin.conf"
echo "ExecStart=" >> "/etc/systemd/system/getty@tty1.service.d/autologin.conf"
echo "ExecStart=-/sbin/rungetty tty1 -u root -- login -f root" >> "/etc/systemd/system/getty@tty1.service.d/autologin.conf"
if [ "`grep \"startx\" /root/.profile`" == "" ]; then
	echo  >> /root/.profile
	echo 'if [ "`tty`" == "/dev/tty1" ]; then' >> /root/.profile
	echo '  echo "Start ChamSys MagicQ..."' >> /root/.profile
	echo '	startx' >> /root/.profile
	echo '	clear' >> /root/.profile
	echo 'fi' >> /root/.profile
fi


if [ ! -f mouse.png ]; then
  echo
  echo "Download mouse start-menu icon"
  wget http://www.theducks.de/chamsys/mouse.png
fi



cat > /root/.Xsession << EOF
#/bin/bash
xset s 14400
xset s blank
xset dpms 14400 14700 15000
# xrandr -s 1280x1024
xcompmgr &
pcmanfm --desktop &
tint2 &
exec openbox-session
EOF
chmod 755 /root/.Xsession

# Setzt GTK Theme zu Clearlooks
cat > /root/.gtkrc-2.0 << EOF
gtk-theme-name="Clearlooks"
gtk-icon-theme-name="nuoveXT2"
gtk-font-name="Sans 10"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
gtk-xft-rgba="none"
EOF

mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.xml << EOF
[Settings] 
gtk-theme-name=Clearlooks
gtk-icon-theme-name=nuoveXT2
gtk-font-name=Sans 10
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=none
EOF

cat > /root/.gtk-bookmarks << EOF
file:///home/chamsys ChamSys
EOF

mkdir -p /root/.config/pcmanfm/default/
cat > /root/.config/pcmanfm/default/pcmanfm.conf << EOF
[config]
bm_open_method=0
su_cmd=gksu %s

[volume]
mount_on_startup=0
mount_removable=0
autorun=0

[desktop]
wallpaper_mode=2
wallpaper=
desktop_bg=#0a3b76
desktop_fg=#ffffff
desktop_shadow=#000000
desktop_font=Sans 8
show_wm_menu=1

[ui]
always_show_tabs=0
max_tab_chars=32
win_width=640
win_height=480
splitter_pos=150
side_pane_mode=1
view_mode=3
show_hidden=0
sort_type=0
sort_by=2
EOF

mkdir -p /root/.config/tint2
cat > /root/.config/tint2/tint2rc << EOF
# Tint2 config file
# Generated by tintwizard (http://code.google.com/p/tintwizard/)
# For information on manually configuring tint2 see http://code.google.com/p/tint2/wiki/Configure

# Background definitions
# ID 1
rounded = 0
border_width = 0
background_color = #000000 40
border_color = #000000 16

# ID 2
rounded = 3
border_width = 0
background_color = #FFFFFF 40
border_color = #FFFFFF 48

# ID 3
rounded = 3
border_width = 0
background_color = #FFFFFF 16
border_color = #FFFFFF 68

# ID 4
rounded = 3
border_width = 0
background_color = #000000 85

# Panel
panel_monitor = all
panel_position = bottom center horizontal
panel_items = LTSBC
panel_size = 100% 30
panel_margin = 0 0
panel_padding = 7 0 7
panel_dock = 0
wm_menu = 1
panel_layer = top
panel_background_id = 1

# Panel Autohide
autohide = 0
autohide_show_timeout = 0.3
autohide_hide_timeout = 2
autohide_height = 2
strut_policy = follow_size

# Taskbar
taskbar_mode = single_desktop
taskbar_padding = 2 3 2
taskbar_background_id = 0
taskbar_active_background_id = 0

# Tasks
urgent_nb_of_blink = 2
task_icon = 1
task_text = 1
task_centered = 0
task_maximum_size = 140 35
task_padding = 6 2
task_background_id = 3
task_active_background_id = 2
task_urgent_background_id = 2
task_iconified_background_id = 3
task_tooltip = 1

# Task Icons
task_icon_asb = 70 0 0
task_active_icon_asb = 100 0 0
task_urgent_icon_asb = 100 0 0
task_iconified_icon_asb = 70 0 0

# Fonts
task_font = sans 8
task_font_color = #FFFFFF 68
task_active_font_color = #FFFFFF 83
task_urgent_font_color = #FFFFFF 83
task_iconified_font_color = #FFFFFF 68
font_shadow = 0

# System Tray
systray = 1
systray_padding = 0 4 5
systray_sort = ascending
systray_background_id = 0
systray_icon_size = 16
systray_icon_asb = 70 0 0

# Clock
time1_format = %H:%M
time1_font = sans 8
time2_format = %A %d %B
time2_font = sans 6
clock_font_color = #FFFFFF 74
clock_padding = 1 0
clock_background_id = 0
clock_rclick_command = orage

# Tooltips
tooltip_padding = 2 2
tooltip_show_timeout = 0.7
tooltip_hide_timeout = 0.3
tooltip_background_id = 4
tooltip_font = sans 10
tooltip_font_color = #FFFFFF 80

# Mouse
mouse_middle = none
mouse_right = none
mouse_scroll_up = toggle
mouse_scroll_down = iconify

# Battery
battery = 0
battery_low_status = 10
battery_low_cmd = notify-send "battery low"
battery_hide = 98
bat1_font = sans 8
bat2_font = sans 6
battery_font_color = #FFFFFF 74
battery_padding = 1 0
battery_background_id = 0

# Applications
launcher_padding = 0 0 10
launcher_background_id = 0
launcher_icon_size = 26
launcher_item_app = /usr/share/applications/menu.desktop
launcher_item_app = /usr/share/applications/magicq.desktop

# End of config
EOF

cat > /usr/share/applications/menu.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Tint2 Openbox Menu
Comment=Tint2 Openbox Menu
X-GNOME-FullName=Openbox Menu
Exec=xdotool key super+alt+space
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=$HOME_DIR/mouse.png
Categories=Menu;
MimeType=
StartupNotify=true
EOF


mkdir -p /root/.config/openbox
cat > /root/.config/openbox/menu.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>

<openbox_menu xmlns="http://openbox.org/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://openbox.org/
                file:///usr/share/openbox/menu.xsd">

<menu id="root-menu" label="Openbox 3">
  <item label="Taskbar on top">
    <action name="Execute"><execute>bash -c "$HOME_DIR/scripts/tint2_top.sh"</execute></action>
  </item>
  <item label="Taskbar in background">
    <action name="Execute"><execute>bash -c "$HOME_DIR/scripts/tint2_bottom.sh"</execute></action>
  </item>
  <separator />
  <item label="Terminal">
    <action name="Execute"><execute>x-terminal-emulator</execute></action>
  </item>
  <item label="Firefox">
    <action name="Execute"><execute>x-www-browser</execute></action>
  </item>
  <item label="Filemanager">
    <action name="Execute"><execute>pcmanfm</execute></action>
  </item>
  <item label="PDF Viewer">
    <action name="Execute"><execute>epdfview</execute></action>
  </item>
  <item label="Taskmanager">
    <action name="Execute"><execute>lxtask</execute></action>
  </item>
  <item label="Monitor Settings">
    <action name="Execute"><execute>lxrandr</execute></action>
  </item>
  <item label="Input Settings">
    <action name="Execute"><execute>lxinput</execute></action>
  </item>
  <item label="Get DHCP IP">
    <action name="Execute"><execute>bash -c "dhclient -r eth0; dhclient eth0"</execute></action>
  </item>
  <item label="Reconfigure">
    <action name="Reconfigure" />
  </item>
  <separator />
  <item label="Exit">
    <action name="Exit">
      <prompt>no</prompt>
    </action>
  </item>
  <item label="Shutdown">
    <action name="Execute">
      <prompt>Are you shure that you want to shut down the system?</prompt>
      <command>/sbin/poweroff</command>
    </action>
  </item>
  <item label="Reboot">
    <action name="Execute">
      <prompt>Are you shure that you want to reboot the system?</prompt>
      <command>reboot</command>
    </action>
  </item>
</menu>

</openbox_menu>
EOF

cat > /root/.config/openbox/rc.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc">

<resistance>
  <strength>10</strength>
  <screen_edge_strength>20</screen_edge_strength>
</resistance>

<focus>
  <focusNew>yes</focusNew>
  <followMouse>no</followMouse>
  <focusLast>yes</focusLast>
  <underMouse>no</underMouse>
</focus>

<placement>
  <policy>Smart</policy>
  <center>yes</center>
  <monitor>Active</monitor>
  <primaryMonitor>1</primaryMonitor>
</placement>

<theme>
  <name>Clearlooks</name>
  <titleLayout>NLIMC</titleLayout>
  <keepBorder>yes</keepBorder>
  <animateIconify>yes</animateIconify>
  <font place="ActiveWindow">
    <name>sans</name>
    <size>8</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="InactiveWindow">
    <name>sans</name>
    <size>8</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="MenuHeader">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="MenuItem">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="OnScreenDisplay">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
</theme>

<desktops>
  <number>1</number>
  <firstdesk>1</firstdesk>
  <popupTime>0</popupTime>
</desktops>

<resize>
  <drawContents>yes</drawContents>
  <popupShow>Nonpixel</popupShow>
  <popupPosition>Center</popupPosition>
</resize>

<margins>
  <top>0</top>
  <bottom>0</bottom>
  <left>0</left>
  <right>0</right>
</margins>

<keyboard>
  <chainQuitKey>C-g</chainQuitKey>

  <!-- Keybindings for desktop switching -->
  <keybind key="W-d">
    <action name="ToggleShowDesktop"/>
  </keybind>

  <!-- Keybindings for windows -->
  <keybind key="A-F4">
    <action name="Close"/>
  </keybind>
  <keybind key="A-Escape">
    <action name="Lower"/>
    <action name="FocusToBottom"/>
    <action name="Unfocus"/>
  </keybind>
  <keybind key="A-space">
    <action name="ShowMenu"><menu>client-menu</menu></action>
  </keybind>
  <keybind key="Print">
    <action name="Execute"><execute>gnome-screenshot</execute></action>
  </keybind>
  <keybind key="A-Print">
    <action name="Execute"><execute>gnome-screenshot -w</execute></action>
  </keybind>

  <!-- Keybindings for window switching -->
  <keybind key="A-Tab">
    <action name="NextWindow"/>
  </keybind>
  <keybind key="A-S-Tab">
    <action name="PreviousWindow"/>
  </keybind>
  <keybind key="C-A-Tab">
    <action name="NextWindow">
      <panels>yes</panels><desktop>yes</desktop>
    </action>
  </keybind>

  <!-- Keybindings for running applications -->
  <keybind key="W-e">
    <action name="Execute">
      <startupnotify>
        <enabled>true</enabled>
        <name>pcmanfm</name>
      </startupnotify>
      <command>pcmanfm</command>
    </action>
  </keybind>

  <keybind key="W-A-space">
    <action name="ShowMenu"><menu>root-menu</menu></action>
  </keybind>
</keyboard>

<mouse>
  <dragThreshold>8</dragThreshold>
  <doubleClickTime>200</doubleClickTime>
  <screenEdgeWarpTime>0</screenEdgeWarpTime>

  <context name="Frame">
    <mousebind button="A-Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="A-Left" action="Click">
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="A-Left" action="Drag">
      <action name="Move"/>
    </mousebind>

    <mousebind button="A-Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="A-Right" action="Drag">
      <action name="Resize"/>
    </mousebind> 

    <mousebind button="A-Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="C-A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="C-A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="A-S-Up" action="Click">
      <action name="SendToDesktopPrevious"/>
    </mousebind>
    <mousebind button="A-S-Down" action="Click">
      <action name="SendToDesktopNext"/>
    </mousebind>
  </context>

  <context name="Titlebar">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Move"/>
    </mousebind>
    <mousebind button="Left" action="DoubleClick">
      <action name="ToggleMaximizeFull"/>
    </mousebind>

    <mousebind button="Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="Up" action="Click">
      <action name="Shade"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
      <action name="Lower"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="Unshade"/>
      <action name="Raise"/>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="Top">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>top</edge></action>
    </mousebind>
  </context>

  <context name="Left">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>left</edge></action>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="Right">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>right</edge></action>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="Bottom">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>bottom</edge></action>
    </mousebind>

    <mousebind button="Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="BLCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="BRCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="TLCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="TRCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="Client">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Middle" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
  </context>

  <context name="Icon">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="AllDesktops">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleOmnipresent"/>
    </mousebind>
  </context>

  <context name="Shade">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleShade"/>
    </mousebind>
  </context>

  <context name="Iconify">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="Iconify"/>
    </mousebind>
  </context>

  <context name="Maximize">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Middle" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleMaximizeFull"/>
    </mousebind>
    <mousebind button="Middle" action="Click">
      <action name="ToggleMaximizeVert"/>
    </mousebind>
    <mousebind button="Right" action="Click">
      <action name="ToggleMaximizeHorz"/>
    </mousebind>
  </context>

  <context name="Close">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="Close"/>
    </mousebind>
  </context>

  <context name="Desktop">
    <mousebind button="Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>

    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="C-A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="C-A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>

    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
  </context>

  <context name="Root">
    <!-- Menus -->
    <mousebind button="Middle" action="Press">
      <action name="ShowMenu"><menu>client-list-combined-menu</menu></action>
    </mousebind> 
    <mousebind button="Right" action="Press">
      <action name="ShowMenu"><menu>root-menu</menu></action>
    </mousebind>
  </context>

  <context name="MoveResize">
    <mousebind button="Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
  </context>
</mouse>

<applications>
  <application class="*">
    <decor>yes</decor>
  </application> 
  <application title="*MagicQ PC*">
    <decor>no</decor>
    <maximized>yes</maximized>
  </application>
  <application title="Microwindows">
    <decor>no</decor>
    <maximized>yes</maximized>
  </application>
</applications>

</openbox_config>
EOF

mkdir -p $HOME_DIR/scripts

cat > $HOME_DIR/scripts/tint2_bottom.sh << EOF
#!/bin/bash
CONFIG=/root/.config/tint2/tint2rc
sed -i "s/panel_layer.*/panel_layer = bottom/g" \$CONFIG
sed -i "s/strut_policy.*/strut_policy = none/g" \$CONFIG
killall tint2
tint2 &
EOF
chmod +x $HOME_DIR/scripts/tint2_bottom.sh

cat > $HOME_DIR/scripts/tint2_top.sh << EOF
#!/bin/bash
CONFIG=/root/.config/tint2/tint2rc
sed -i "s/panel_layer.*/panel_layer = top/g" \$CONFIG
sed -i "s/strut_policy.*/strut_policy = follow_size/g" \$CONFIG
killall tint2
tint2 &
EOF
chmod +x $HOME_DIR/scripts/tint2_top.sh
