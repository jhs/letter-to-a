#!/bin/bash
#
# Convert Letter source to A4

root=$(dirname ${BASH_SOURCE})
source_dir=${root}/source

# Edit these for debugging and testing
styles () { echo BW Color; }
sizes () { echo A3 A4 A5; }

main () {
  prep_source_files

  for size in $(sizes) ; do
    for style in $(styles) ; do
      echo "== Build: $size $style ==" >&2
      local target=$(target_name $style $size $zoom)

      for page_num in $(page_numbers) ; do
        local source=$(source_file $style $page_num)
        convert_page ${source} ${target} ${page_num} ${size} ${zoom} || exit $?
      done

      collate $size $style $zoom
      echo "" >&2
    done
  done
}

convert_page () {
  local source=${1}
  local target_name=${2}
  local page_num=${3}
  local page_size=$(echo $4 | tr A-Z a-z)

  local target_dir=${target_name}/pages
  local target_file=${target_name}/pages/Chart-$(pad ${page_num}).pdf

  local opts="-q -sDEVICE=pdfwrite -sPAPERSIZE=$page_size -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4"

  echo "Convert: $source -> $target_file" >&2
  echo "  gs $opts -o $target_file $source" >&2

  mkdir -p ${target_dir}
  gs $opts -o ${target_file} ${source}
}

# This is for posterity, but it does not really work well enough.
#zoom_command () {
#  local scale=1
#  case "$1" in
#    'FullZoom') scale=1.12 ;;
#    *) : ;;
#  esac
#
#  local height=210 # mm
#  local mm_to_pt=2.8346456664
#  height=$(echo "$height * $mm_to_pt" | bc)
#  local growth=$(echo "($scale - 1.0) * $height" | bc)
#  local ty=-$(echo "$growth / 2.0" | bc)
#
#  local width=297 # mm
#  width=$(echo "$width * $mm_to_pt" | bc)
#  local growth=$(echo "($scale - 1.0) * $width" | bc)
#  local tx=-$(echo "$growth / 2.0" | bc)
#
#  echo "<</BeginPage{$scale $scale scale $tx $ty translate}>> setpagedevice"
#}

source_file () {
  local style=$1
  local num=$2

  local name='Chart'
  if [ $style = 'Color' ]; then
    name='ChartC'
  fi

  echo "$root/source/Mag7-$style/$name-$num.pdf"
}

target_name () {
  local style=$1
  local size=$2
  local dir="$root/target/$size/$style"

  mkdir -p ${dir}
  echo ${dir}
}

collate () {
  local size=$1
  local style=$2

  local target_name=$(target_name $style $size)
  local source_dir=${target_name}/pages

  local target_file="${target_name}/Mag7-$style-$size.pdf"
  local page_size=$(echo $size | tr A-Z a-z)

  local opts="-q -sDEVICE=pdfwrite -sPAPERSIZE=$page_size -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4"

  echo "Collate: $target_name" >&2
  echo "  gs $opts -o $target_file $source_dir/*.pdf" >&2
  gs $opts -o ${target_file} ${source_dir}/*.pdf
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

prep_source_files () {
  local needs_extraction=''
  for style in $(styles) ; do
    local source_style=${source_dir}/Mag7-$style
    if [ ! -d ${source_style} ]; then
      echo "Missing source directory: $source_style" >&2
      needs_extraction=true
    fi
  done

  if [ ${needs_extraction} ]; then
    echo "Extract source files..." >&2
    tar xzf ${source_dir}/mag7-all.tar.xz -C ${source_dir}
  fi
}

clean () {
  echo "Clean..." >&2
  rm -rf ${root}/target ${root}/source/Mag7-*
}

case $1 in
  'clean') clean ;;
  *) main ;;
esac
