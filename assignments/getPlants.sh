#!/bin/bash
#
# Extracts data records from "Native Plants" brochure, outputs as normalized CSV.
#
# Assumes and correctly processes: (omitting unusable data as needed)
# - One .START and one .END marker placed manually before/after data to extract
# - Some data corrupted by PDF copy/paste, with lines out of order :(

# Output atributes heading, process each line of input.
echo "Category, Common Name, Latin Name, Type, Height, Width, Growth Habit, Description"
while IFS= read line; do lineNum=$(( $lineNum + 1 ))

  # Non-record line? Skip it.
  [[ "${line}" =~ ^.START ]] && started=1 && echo "!! START" >&2 && continue; [[ ! $started ]] && continue  # Front matter
  [[ $( grep -E '^ *[0-9]+ *$' <<<"$line" ) ]] && continue  # Page number
  [[ $( grep -E '^ *Plant icon key on pages' <<<"$line" ) ]] && continue  # Footnote

  # New categoy group of records? Save it.
  [[ "$line" =~ Large\ trees ]] && category="Large Tree" && continue; [[ ! "$category" ]] && continue
  [[ "$line" =~ Small\ trees ]] && category="Small Tree" && continue; [[ ! "$category" ]] && continue
  [[ "$line" =~ Large\ shrubs ]] && category="Large Shrub" && continue; [[ ! "$category" ]] && continue
  [[ "$line" =~ Small\ and\ medium\ shrubs ]] && category="Small/Medium Shrub" && continue; [[ ! "$category" ]] && continue
  [[ "$line" =~ Perennials,\ annuals\ and\ ferns ]] && category="Perennial/Annual/Fern" && continue; [[ ! "$category" ]] && continue

  # New record or end of records? Output completed, normalized record.
  if [[ $line =~ ^\ \ \ \  || $line =~ \.END ]]; then 
    if [[ "$name" ]]; then
      warning="!! Missing $( tr 'a-z' 'A-Z' <<<$name ) data (starting with \"DATA\") on line ${lineNum}"
      [[ "$name"     && ! "$category" ]] && echo "${warning/DATA/plant category}" >&2
      [[ "$category" && ! "$latin"    ]] && echo "${warning/DATA/latin name}" >&2
      [[ "$latin"    && ! "$type"     ]] && echo "${warning/DATA/plant type}" >&2
      [[ "$type"     && ! "$size"     ]] && echo "${warning/DATA/plant size}" >&2
      [[ "$size"     && ! "$growth"   ]] && echo "${warning/DATA/growth habit}" >&2
      [[ "$growth"   && ! "$desc"     ]] && echo "${warning/DATA/description}" >&2
      printf '%s\n' "${category},${name},${latin},${type},${size},${growth},${desc}"
      [[ $line =~ \.END ]] && echo "!! END" >&2 && break
      name=""; latin=""; type=""; size=""; growth=""; desc=""
    fi
  fi

  # Invalid/unexpected data? Warn about it.
  if [[ ! "$name" && $( grep -E '^[^[:space:]]' <<<"$line" ) ]]; then echo "!! Invalid/unexpected data on line ${lineNum}: $line" >&2; continue; fi

  # Field value(s)? Normalize them.
  # Includes separating "size" and "growth" from line of "size" AND "growth", and separating "type" from "size/growth" in occasional line of "type" AND "size/growth".
  line=$( sed 's/^ *//;s/ *$//' <<<"$line" )  # Remove head/tail whitespace
  [[ ! "$name" ]]  && name="$line" && continue
  [[ ! "$latin" ]] && latin="$line" && continue
  if [[ ! "$type" ]]; then type="${line%% [0-9]*}"; line="$( sed -E 's/^[^0-9]+([0-9])/\1/' <<<"$line" )"; [[ "$type" == "$line" ]] && continue; fi
  if [[ ! "$size" ]]; then size="${line%% [A-Z]*}"; growth="$( sed -E 's/^[^A-Z]+//' <<<"$line" )"; continue; fi
  if [[ ! "$desc" ]]; then desc="$line"; desc="${desc//,/;}"; fi

done
