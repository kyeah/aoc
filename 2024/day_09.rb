PRINT_DEBUG=false

def log(msg)
  return unless PRINT_DEBUG
  p msg
end

class Block < Struct.new(:start, :end, :size); end

class Disk < Struct.new(:disk, :seen)
  def can_move_fileblock?(idx)
    # should have just kept a record of the smallest seen value but yolo
    self.disk[idx] != "." && !self.seen[self.disk[idx]]
  end
  
  def inbounds?(idx)
    idx >= 0 && idx < self.disk.length
  end

  def checksum
    self.disk.each_with_index.reduce(0) do |accum, (val, idx)|
      next accum if val == "."
      accum + val * idx
    end
  end

  def compact!
    free_idx = 0
    fileblock_idx = self.disk.length - 1
  
    while true
      free_idx += 1 while self.disk[free_idx] != "."
      fileblock_idx -= 1 while self.disk[fileblock_idx] == "."
  
      return if free_idx >= fileblock_idx
      self.disk[free_idx] = self.disk[fileblock_idx]
      self.disk[fileblock_idx] = "."
    end
  end

  def find_blocksize(start, dir)
    end_idx = start
    end_idx += dir while self.disk[end_idx + dir] == self.disk[start]
    file_size = (end_idx - start).abs + 1

    if dir > 0
      Block.new(start, end_idx, file_size)
    else
      Block.new(end_idx, start, file_size)
    end
  end

  def find_freeblock(file_block)
    log "Finding free size"
    block = Block.new(0, -1, -1)
    
    # Iterate over free blocks until there's one that fits so we can sits
    while block.size < file_block.size && block.start < file_block.start
      # Increment past the current free space if we're on one -- if we're here, the space is too small
      block.start += 1 while self.disk[block.start] === "."

      # Increment until the next free space
      block.start += 1 while self.inbounds?(block.start) && self.disk[block.start] != "."
      break if !self.inbounds?(block.start)
      
      # Find free block size
      block = self.find_blocksize(block.start, 1)
      log "Potential free space: #{block.size}, indexes #{block.start}, #{block.end}"
    end

    block
  end

  def swap!(file_block, free_block)
    # yes this modifies the arguments being passed in, what r u gonna do bout it punk
    while file_block.end >= file_block.start
      self.disk[free_block.start] = self.disk[file_block.end]
      self.disk[file_block.end] = "."
      free_block.start += 1
      file_block.end -= 1
    end
  end

  def compact_2!
    fileblock_idx_end = self.disk.length - 1
    seen = {}
  
    # Definitely a faster way to do this by keeping track of free blocks and file blocks, and potentially even
    # keeping a hashmap of free block sizes but I don't want to figure out
    # merging free blocks together, keeping ordered list, etc. etc.
    while fileblock_idx_end > 0
      log self.disk.join("")
  
      # Figure out file size
      while !self.can_move_fileblock?(fileblock_idx_end)
        fileblock_idx_end -= 1
        return if !self.inbounds?(fileblock_idx_end)
      end
  
      file_num = self.disk[fileblock_idx_end]
      file_block = self.find_blocksize(fileblock_idx_end, -1)
      p "Filesize: #{file_block.size}, Filenum: #{file_num}"
  
      # Figure out free size
      free_block = self.find_freeblock(file_block)
      log "Free size: #{free_block.size}, indexes #{free_block.start}, #{free_block.end}"
  
      self.seen[file_num] = true
      if free_block.start >= file_block.start
        # Skip dis file, it's hopeless
        fileblock_idx_end -= 1 while self.disk[fileblock_idx_end] == file_num
        log "Skipping #{file_num}"
        next
      end
  
      # swaparoo
      log "Swapping #{file_num}"
      self.swap!(file_block, free_block)
      fileblock_idx_end = file_block.start - 1
    end
  end
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

  Disk.new(disk, [])
end

def part1
  disk = input
  disk.compact!
  disk.checksum
end

p part1

def part2
  disk = input
  disk.compact_2!
  p disk.disk.join("")
  disk.checksum
end

p part2