if ! ping -c 1 google.com > /dev/null 2>&1; then
    ui_print "- Error: No internet connection detected!"
    abort
fi
if [ -f "/system/product/media/bootanimation.zip" ]; then
    tf="/system/product/media"
    mkdir -p "$MODPATH$tf"
elif [ -f "/system/media/bootanimation.zip" ]; then
    tf="/system/media"
    mkdir -p "$MODPATH$tf"
else
    ui_print "! This Device Isn't Supported "
    abort
fi
ui_print "- Detected Bootanimation Path: $tf"
sleep 0.3
ui_print "..."
sleep 0.3
ui_print "..."
sleep 0.3
ui_print "..."
choose_option() {
    local current=$1
    local event
    event=$(getevent -qlc 1 2>/dev/null)
    if echo "$event" | grep -q "KEY_VOLUMEUP"; then
        return 1
    elif echo "$event" | grep -q "KEY_VOLUMEDOWN"; then
        return 0
    fi
    return 2
}
show_menu() {
    local current=$1
    case $current in
        1) ui_print "- [*] Style 1 (12MB) " ;;
        2) ui_print "- [*] Style 2 (9.9MB)" ;;
        3) ui_print "- [*] Style 3 (5.7MB)" ;;
        4) ui_print "- [*] Style 4  (60MB)" ;;
    esac
}
ui_print "- Use VOLUME KEYS To Select The Bootanimation "
sleep 1
ui_print "===================="
ui_print "- Volume [+] : Next Style"
ui_print "- Volume [-] : Select The Style"
ui_print "===================="
current_option=1
selected=0
while [ $selected -eq 0 ]; do
    show_menu $current_option
    choose_option $current_option
    case $? in
        0)
            selected=$current_option
            ui_print "Selected : $selected"
            ;;
        1)
            current_option=$((current_option + 1))
            if [ $current_option -gt 4 ]; then
                current_option=1
            fi
            ;;
    esac
    sleep 0.3
done
ui_print "- Downloading STYLE $selected......"
URL="https://raw.githubusercontent.com/f33a6a/Bootleggers-Bootanimations/main/bootanimation/style${selected}.zip"

if ! busybox wget -O "$MODPATH$tf/bootanimation.zip" "$URL"; then
    ui_print "! Download failed"
    abort
fi
set_perm_recursive "$MODPATH/system" 0 0 0755 0644

ui_print "- Installation complete!"