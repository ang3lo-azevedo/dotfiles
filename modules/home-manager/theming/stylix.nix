{
  pkgs,
  inputs,
  ...
}: let
  appleColorEmojiPackage = inputs.berberman.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji;
in {
  stylix = {
    enable = true;

    # Activate dark mode
    polarity = "dark";

    targets = {
      zen-browser.colors.enable = true;
      vscode.colors.enable = false;
      # rofi is not used (programs.rofi.enable is false), and stylix themes it through
      # the pre-rename programs.rofi.font option, which warns on every evaluation
      rofi.enable = false;

      gtk.extraCss = ''
        /* Force all GTK animations to be very fast */
        * {
          transition-duration: 0.1s;
          animation-duration: 0.1s;
        }

        /* adw-gtk3's light variant hardcodes near-black text on GTK3 message dialog buttons */
        messagedialog.csd.background button:not(.suggested-action):not(.destructive-action) {
          color: @dialog_fg_color;
        }

        messagedialog.csd.background button:not(.suggested-action):not(.destructive-action):backdrop,
        messagedialog.csd.background button:not(.suggested-action):not(.destructive-action):disabled {
          color: alpha(@dialog_fg_color, 0.5);
        }

        .hotkey-overlay {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          background-color: #000000;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 8px;
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
        }

        .hotkey-overlay row {
          border-radius: 6px;
          padding: 2px 8px;
        }

        .hotkey-overlay row:hover {
          background-color: #2a2a2a;
        }
      '';
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = appleColorEmojiPackage;
        name = "Apple Color Emoji";
      };
    };

    # Custom base16 color scheme: pitch-dark OLED black (000000) for all system windows,
    # with muted, non-vibrant syntax colors (easy on the eyes, avoids fluorescent glare).
    base16Scheme = {
      # Zed rejects the generated theme without it: "unspecified" is not a valid appearance
      variant = "dark";
      base00 = "000000"; # Default Background (Pitch Black OLED for all desktop windows)
      base01 = "0d0d0d"; # Lighter Background (status bars, line numbers, sidebars)
      base02 = "1c1c1c"; # Selection Background
      base03 = "686868"; # Comments, Invisibles, Line Highlighting (readable grey)
      base04 = "999999"; # Dark Foreground (Used for status bars)
      base05 = "d4d4d4"; # Default Foreground, Caret, Delimiters, Operators (soft off-white)
      base06 = "ededed"; # Light Foreground (Not often used)
      base07 = "ffffff"; # Light Background (Not often used)
      base08 = "e06c75"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted (muted soft red)
      base09 = "d19a66"; # Integers, Boolean, Constants, XML Attributes (muted peach/amber)
      base0A = "e5c07b"; # Classes, Search Text (muted golden sand)
      base0B = "98c379"; # Strings, Inherited Class, Markup Code, Diff Inserted (soft sage green)
      base0C = "56b6c2"; # Support, Regular Expressions, Escape Characters, Markup Quotes (muted slate cyan/teal)
      base0D = "61afef"; # Functions, Methods, Attribute IDs, Headings (soft calm sky blue)
      base0E = "c678dd"; # Keywords, Storage, Selector, Markup Italic, Diff Changed (soft lavender purple)
      base0F = "d884b8"; # Deprecated, Opening/Closing Embedded Language Tags (muted dusty rose)
    };
  };
}
