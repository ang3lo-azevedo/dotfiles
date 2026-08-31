import re

with open('/home/ang3lo/nix-config/flake.nix', 'r') as f:
    content = f.read()

# Remove angr-management input block
content = re.sub(r'\s*# angr-management source.*?angr-management = \{[^}]+\};', '', content, flags=re.DOTALL)
# Remove ist-fenix-auto-enroller input block
content = re.sub(r'\s*ist-fenix-auto-enroller = \{[^}]+\};', '', content, flags=re.DOTALL)
# Remove autodesk-fusion input block
content = re.sub(r'\s*autodesk-fusion = \{[^}]+\};', '', content, flags=re.DOTALL)

with open('/home/ang3lo/nix-config/flake.nix', 'w') as f:
    f.write(content)
