TOUCHPAD_ID=$(xinput list | grep -i touchpad | grep -o 'id=[0-9]*' | cut -d= -f2)
if [ -n "$TOUCHPAD_ID" ]; then
  ENABLED=$(xinput list-props "$TOUCHPAD_ID" | grep "Device Enabled" | grep -o '[01]$')
  if [ "$ENABLED" = "1" ]; then
    xinput disable "$TOUCHPAD_ID"
  else
    xinput enable "$TOUCHPAD_ID"
  fi
fi
