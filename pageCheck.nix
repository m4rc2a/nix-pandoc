# SPDX-FileCopyrightText: 2026 Marc Zander <https://github.com/m4rc2a>
#
# SPDX-License-Identifier: MPL-2.0
#
# Helper: generate a checkPhase snippet that verifies the page count of a
# generated PDF via pdfinfo (poppler-utils must be present, e.g. via
# mkDoc's extraBuildInputs). Exposed through the flake output `lib`:
#
#   nix-pandoc.lib.pageCheck {
#     file = "$out/flexray.pdf";   # path inside the derivation
#     min = 3;
#     max = 5;
#   }
#
# Return value is a bash snippet; pass it to mkDoc as `checkPhase` (mkDoc
# forwards arbitrary stdenv.mkDerivation attributes) and add a `checkPhase`
# to `phases`. `nix flake check` then fails if the page count is out of range.
{ file
, min ? 1
, max ? 1000000
}:
''
  pages=$(pdfinfo "${file}" | awk '/^Pages:/ {print $2}')
  test -n "$pages"
  test "$pages" -ge ${toString min} && test "$pages" -le ${toString max}
  echo "PDF page count: $pages (expected ${toString min}-${toString max})"
''
