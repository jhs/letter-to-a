#!/bin/bash
#
# Convert Letter source to A4

main () {
  for style in $(styles) ; do
    for page_num in $(page_numbers) ; do
      local source=$(source_file $style $page_num)
      local target=$(target_file $style $page_num)

      convert ${source} ${target}
    done
  done
}

convert () {
  local opts="-sDEVICE=pdfwrite -sPAPERSIZE=a4 -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4"

  echo "gs $opts -o $target $source"
  gs $opts -o ${target} ${source}
}

source_file () {
  local style=$1
  local num=$2
  echo "source/Mag7-$style/Chart-$num.pdf"
}

target_file () {
  local style=$1
  local num=$2
  local filename="Chart-$(pad $num).pdf"
  local dirname="target/Mag7-$style-A4"

  mkdir -p ${dirname}
  echo ${dirname}/${filename}
}

pad () {
  if [[ ${1} =~ ^[0-9]$ ]]; then
    echo "0$1"
  else
    echo "$1"
  fi
}

page_numbers () {
  local head=$(seq 1 11)
  local tail=$(seq 12 20)
  echo "$head 11a $tail"
}

styles () {
  echo BW
  return
  echo "BW COLOR"
}

main
