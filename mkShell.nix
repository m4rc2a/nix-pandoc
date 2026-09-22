# SPDX-FileCopyrightText: 2026 Marc Zander <https://github.com/m4rc2a>
#
# SPDX-License-Identifier: MPL-2.0
#
# Build helper: a reusable development shell for writing Pandoc documents
# (Markdown -> PDF via xelatex). Bundles everything needed to
#   - build:        make, pandoc, texlive (xelatex, tikz, ...)
#   - inspect PDFs: poppler-utils (pdfinfo, pdftotext, pdftoppm)
#
# Exposed as mkShell.${system} via pkgs.callPackage, so from a project flake:
#
#   devShells = { default = nix-pandoc.mkShell.${system} { }; };
#
# Options:
#   texlive-combined  texlive distribution (default: combined.scheme-medium)
#   extraPackages     additional shell packages, e.g. [ pkgs.git ]
{ pkgs }:
{ texlive-combined ? pkgs.texlive.combined.scheme-medium
, extraPackages ? [ ]
, ...
}@args:
pkgs.mkShell ({
  packages = [
    pkgs.gnumake
    pkgs.pandoc
    texlive-combined
    pkgs.poppler-utils
  ] ++ extraPackages;
} // args)
