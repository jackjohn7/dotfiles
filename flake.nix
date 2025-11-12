{
  description = "Dev shell for Nix and Lua development (language servers, formatters, etc.)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Tooling for Lua
        luaTools = with pkgs; [
          lua
          luajit
          stylua          # Lua formatter
          lua-language-server
          luarocks         # Lua package manager
        ];

        # Tooling for Nix itself
        nixTools = with pkgs; [
          nixfmt-rfc-style  # or nixpkgs-fmt, if you prefer
          nil               # Nix language server
          alejandra         # Another popular Nix formatter
        ];

      in {
        devShells.default = pkgs.mkShell {
          name = "nix-lua-dev";
          packages = luaTools ++ nixTools;

          shellHook = ''
            echo "Entering Nix + Lua development shell!"
            echo "Tools available: lua, stylua, nil, nixfmt, alejandra"
          '';
        };
      });
}
