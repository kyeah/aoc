PRINT_DEBUG=false

def log(msg)
  return unless PRINT_DEBUG
  p msg
end

def input
  disk = []

  is_file = true
  file_num = 0

  File.read("./input/day_09.txt").strip.chars.each do |c|
    for i in 0...Integer(c)
      is_file ? disk.append(file_num) : disk.append(".")
    end

    file_num += 1 if is_file
    is_file = !is_file
  end

  disk
end

def part1
  disk = input
  compact!(disk)
  checksum(disk)
end

def compact!(disk)
  free_idx = 0
  fileblock_idx = disk.length - 1

  while true
    free_idx += 1 while disk[free_idx] != "."
    fileblock_idx -= 1 while disk[fileblock_idx] == "."

    return if free_idx >= fileblock_idx
    disk[free_idx] = disk[fileblock_idx]
    disk[fileblock_idx] = "."
  end
end

def checksum(disk)
  disk.each_with_index.reduce(0) do |accum, (val, idx)|
    next accum if val == "."
    accum + val * idx
  end
end

p part1

def part2
  disk = input
  compact_2!(disk)
  p disk.join("")
  checksum(disk)
end

def compact_2!(disk)
  fileblock_idx_end = disk.length - 1
  seen = {}

  # Definitely a faster way to do this by keeping track of free blocks and file blocks, and potentially even
  # keeping a hashmap of free block sizes but I don't want to figure out
  # merging free blocks together, keeping ordered list, etc. etc.
  while fileblock_idx_end > 0
    log disk.join("")

    # Figure out file size
    log "Finding filesize"
    fileblock_idx_end -= 1 while fileblock_idx_end > 0 && (disk[fileblock_idx_end] == "." || seen[fileblock_idx_end])
    break if fileblock_idx_end <= 0

    file_num = disk[fileblock_idx_end]

    fileblock_idx_start = fileblock_idx_end
    fileblock_idx_start -= 1 while disk[fileblock_idx_start - 1] == disk[fileblock_idx_end]
    file_size = fileblock_idx_end - fileblock_idx_start + 1

    p "Filesize: #{file_size}, Filenum: #{file_num}"

    # Figure out free size
    log "Finding free size"
    free_idx_start = 0
    free_idx_end = -1
    free_size = -1
    
    # Iterate over free blocks until there's one that fits so we can sits
    while free_size < file_size && free_idx_start <= disk.length - 1
      # Increment past the current free space if we're on one -- if we're here, the space is too small
      free_idx_start += 1 while disk[free_idx_start] === "."

      # Increment until the next free space
      free_idx_start += 1 while disk[free_idx_start] != "." && free_idx_start <= disk.length - 1
      free_idx_end = free_idx_start
      free_idx_end += 1 while disk[free_idx_end + 1] == "."
      free_size = free_idx_end - free_idx_start + 1

      log "Potential free space: #{free_size}, indexes #{free_idx_start}, #{free_idx_end}"
    end

    log "Free size: #{free_size}, indexes #{free_idx_start}, #{free_idx_end}"

    if free_idx_start >= fileblock_idx_start
      # Skip dis file, it's hopeless
      fileblock_idx_end -= 1 while disk[fileblock_idx_end] == file_num
      log "Skipping #{file_num}"
      next
    end

    seen[file_num] = true

    log "Swapping #{file_num}"
    # swaparoo
    while fileblock_idx_end >= fileblock_idx_start
      disk[free_idx_start] = disk[fileblock_idx_end]
      disk[fileblock_idx_end] = "."
      free_idx_start += 1
      fileblock_idx_end -= 1
    end
  end
end

p part2