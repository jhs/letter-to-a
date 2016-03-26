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
      full_download $size $style
      pages_download $size $style
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
  echo
  echo "All of these versions are $size size ($(size_dim $size))."
}

size_label () {
  case $1 in
    'A5') echo 'Small format' ;;
    'A4') echo 'Normal format' ;;
    'A3') echo 'Large format' ;;
  esac
}

size_dim () {
  case $1 in
    'A5') echo '148mm x 210mm' ;;
    'A4') echo '210mm x 297mm' ;;
    'A3') echo '297mm x 420mm' ;;
  esac
}

style_heading () {
  local size=$1
  local style=$2

  echo
  echo "### $(size_label $size), $(style_label $style)"
}

style_label () {
  case $1 in
    'BW'   ) echo 'black-and-white' ;;
    'Color') echo 'color' ;;
  esac
}

title () {
  echo "Mag-7 Star Atlas: $(size_label $1), $(style_label $2)"
}

full_download () {
  local size=$1
  local style=$2
  local href="$size/$style/Mag7-$style-$size.pdf"

  echo
  echo "Click here for the [$(title $size $style)]($href). Or, click any of the individual pages:"
}

pages_download () {
  local size=$1
  local style=$2

  echo
  for i in $(pages); do
    local href="$size/$style/pages/Chart-$(pad $i).pdf"
    echo "1. [Page $i]($href): $(title $size $style)"
  done
}

pages () {
  seq 1 11
  echo '11a'
  seq 12 20
}

pad () {
  if [[ ${1} =~ ^[0-9]$ ]]; then
    echo "0$1"
  else
    echo "$1"
  fi
}

main
