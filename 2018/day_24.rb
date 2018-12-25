def log(*s)
  # puts(*s)
end

class Group < Struct.new(:id, :num_units, :hp, :dmg, :type, :initiative, :weaknesses, :immunities, :team)
  def power(boost = 0)
    if self.team == "infection"
      self.num_units * self.dmg
    else
      self.num_units * (self.dmg + boost)
    end
  end
end

def mult(g1, g2)
  if g2.immunities.include?(g1.type)
    nil
  elsif g2.weaknesses.include?(g1.type)
    2
  else
    1
  end
end

def select_targets(groups1, groups2, boost)
  picked = []

  groups1.
    sort_by{ |g| [g.power(boost), g.initiative] }.
    reverse.
    map do |g1|
    new_picked = (groups2 - picked)
    .map{ |g2| [g1, g2, mult(g1, g2)] }
    .select{|g1, g2, mult| mult != nil}
    .max_by{|g1, g2, mult| [mult * g1.power(boost), g2.power(boost), g2.initiative] }

    if new_picked
      picked.push(new_picked[1])
      log "#{new_picked[0].id} will attack #{new_picked[1].id} for #{g1.power(boost) * new_picked[2]}"
      new_picked
    else
      [g1, nil, nil]
    end
  end
end

def phase(immune_system, infection, boost = 0)
  immune_system_targets = select_targets(immune_system, infection, boost)
  infection_targets = select_targets(infection, immune_system, boost)

  [*immune_system_targets, *infection_targets]
    .sort_by{|g1,g2,mult| g1.initiative}
  .reverse
    .each do |g1,g2,mult|
    next if !g2 || g1.num_units <= 0 || g2.num_units <= 0
    new_dmg = mult * g1.power(boost)
    log "#{g1.id} #{g1.num_units} #{new_dmg}"
    log "#{g1.id} attacks #{g2.id} killing #{new_dmg / g2.hp} units"
    log "#{g2.id} #{g2.num_units}"
    g2.num_units -= new_dmg / g2.hp
    log "#{g2.id} #{g2.num_units}"
    if g2.num_units <= 0
      immune_system.delete(g2)
      infection.delete(g2)
    end
  end
end

def input
  id = 0
  reading_infection = false
  immune_system, infection = Array.new, Array.new

  File.readlines("./res/day_24.txt").each do |line|
    next if line.include?("Immune System") || line.chomp.length == 0
    if line.include?("Infection")
      id = 0
      reading_infection = true
      next
    end

    log line
    r = /^(\d+) units each with (\d+) hit points( \(.*\))? with an attack that does (\d+) ([a-z]+) damage at initiative (\d+)$/
    matches = line.scan(r)[0]

    weaknesses = []
    immunities = []

    if matches[2]
      matches[2].strip.tr("()", "").split(";").each do |item|
        if item.strip.start_with?("weak to")
          weaknesses += item.strip.sub("weak to ", "").split(",").map(&:strip)
        else
          immunities += item.strip.sub("immune to ", "").split(",").map(&:strip)
        end
      end
    end

    group = Group.new(
      id += 1,
      num_units = matches[0].to_i,
      hp = matches[1].to_i,
      dmg = matches[3].to_i,
      type = matches[4],
      initiative = matches[5].to_i,
      weaknesses,
      immunities,
      team = reading_infection ? "infection" : "immune system"
    )

    log group.inspect
    if reading_infection
      infection.push(group)
    else
      immune_system.push(group)
    end
  end

  [immune_system, infection]
end

def p1
  immune_system, infection = input
  while immune_system.length > 0 && infection.length > 0
    phase(immune_system, infection, 0)
    log "immune system: ", immune_system, "infection: ", infection
  end
  log "immune system: ", immune_system, "infection: ", infection
  puts infection.sum(&:num_units)
end

def p2
  boost = 70
  while true
    log "boost: ", boost
    immune_system, infection = input
    i = 0
    while immune_system.length > 0 && infection.length > 0
      phase(immune_system, infection, boost)
      log "immune system: ", immune_system, "infection: ", infection
    end
    if infection.length <= 0
      puts "boost: ", boost, immune_system.sum(&:num_units)
      break
    else
      boost += 1
    end
  end
end

p1
p2
