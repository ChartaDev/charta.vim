# Create app bundle

Source: https://support.shotgunsoftware.com/hc/en-us/community/posts/209485898-Launching-External-Applications-using-Custom-Protocols-under-OSX

- Open "Script Editor"
- Create new script
- Type contents below:

```
on open location this_URL
    do shell script "~/src/charta/editor_integrations/vim/handler.py" & this_URL & "'"
end open location
```

- Save "OpenInVim" as "Script Bundle"
- Find `Info.plist` inside the bundle (View > Show Bundle Contents)
- Copy before the last two lines (/dict & /plisth)

```
<key>CFBundleIdentifier</key>
<string>com.mycompany.AppleScript.OpenInVim</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>Vim</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>vim</string>
    </array>
  </dict>
</array>
```
