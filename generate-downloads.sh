#!/bin/bash
#
# Generate all the download links.

root=$(dirname ${BASH_SOURCE})
target=${root}/target

main () {
  mkdir -p ${root}/target
  cat ${root}/download-head.md

  for size in A3 A4 A5; do
    size_heading $size
    for style in BW Color; do
      style_heading $size $style
    done
  done
}

size_heading () {
  local size=$1

  local label=$(size_label $size)
  case $size in
    'A5') local desc='half-page, A5' ;;
    'A4') local desc='A4' ;;
    'A3') local desc='double-page, A3' ;;
  esac

  echo
  echo "## $label ($desc)"
}

size_label () {
  case $1 in
    'A5') echo 'Small format' ;;
    'A4') echo 'Normal format' ;;
    'A3') echo 'Large format' ;;
  esac
}

style_heading () {
  :
}

main
