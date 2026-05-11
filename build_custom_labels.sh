#!/bin/zsh

SCRIPT_DIR="${0:A:h}"

echo "Copying custom labels to fragments/labels/ ..."
cp "${SCRIPT_DIR}/fragments/custom/"*.sh "${SCRIPT_DIR}/fragments/labels/"
echo "Done."

"${SCRIPT_DIR}/assemble.sh" --labels fragments/custom --script
