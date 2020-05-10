class Game < ApplicationRecord
  has_many :players

  def generate_map
    max_width = 30
    max_height = 30
    valid_loop = false

    while !valid_loop
      puts "NEW ATTEMPT"
      new_map = Array.new(max_height)
      key = 0
      new_map.each do |value|
        new_map[key] = Array.new(max_width)
        new_map[key][0] = '0'
        new_map[key][max_width - 1] = '0'
        key = key + 1
      end
      key = 0
      new_map[0].each do |n|
        new_map[0][key] = '0'
        key = key + 1
      end
      key = 0
      new_map[max_height - 1].each do |n|
        new_map[max_height - 1][key] = '0'
        key = key + 1
      end

      room_count = 0
      room_count_sm = 0
      room_count_md = 0
      room_count_lg = 0

      max_rooms = 15
      max_rooms_sm = 0
      max_rooms_md = 14
      max_rooms_lg = 1

      starting_room_x = 0
      starting_room_y = 0

      potential_doors = {}
      attempts = 0


      while room_count == 0

        potential_room_x = rand(max_width)
        potential_room_y = rand(max_height)
        if potential_room_x - 2 < 0 or potential_room_y - 2 < 0 or potential_room_x + 3 >= max_width or potential_room_y + 1 >= max_height
          next
        end

        valid = true
        # for x in (potential_room_x - 2)..(potential_room_x + 2)
        #   for y in (potential_room_y - 2)..(potential_room_y + 2)
        #     if new_map[y][x] == 1 or new_map[y][x] == 2
        #       valid = false
        #       break
        #     end
        #   end
        #   unless valid
        #     break
        #   end
        # end
        unless valid
          next
        end

        for x in (potential_room_x - 2)..(potential_room_x + 3)
          for y in (potential_room_y - 2)..(potential_room_y + 1)
            if x == potential_room_x - 2 and y == potential_room_y - 2
              new_map[y][x] = 6
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif x == potential_room_x - 2 and y == potential_room_y + 1
              new_map[y][x] = 9
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif x == potential_room_x + 3 and y == potential_room_y - 2
              new_map[y][x] = 7
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif x == potential_room_x + 3 and y == potential_room_y + 1
              new_map[y][x] = 8
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif x == potential_room_x - 2
              new_map[y][x] = 5
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif y == potential_room_y - 2
              new_map[y][x] = 2
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif x == potential_room_x + 3
              new_map[y][x] = 3
              potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            elsif y == potential_room_y + 1
              new_map[y][x] = 4
              #potential_doors = potential_doors.merge({potential_doors.length => {'x' => x, 'y' => y}})
            else
              new_map[y][x] = 1
            end

            #
            # if x == potential_room_x - 3 or x == potential_room_x + 3 or y == potential_room_y - 3 or y == potential_room_y + 3
            #   new_map[y][x] = 1
            # else
            #   new_map[y][x] = 2
            # end
          end
        end
        if room_count_lg == 0
          new_map[potential_room_y + 1][potential_room_x] = 'p'
          starting_room_x = potential_room_x
          starting_room_y = potential_room_y
        end

        room_count += 1
        room_count_lg += 1
      end

      #first hallway
      current_position_x = starting_room_x
      current_position_y = starting_room_y


    num_potential_doors = potential_doors.length

    while room_count < max_rooms and potential_doors.length > 0 and attempts < 300
      attempts = attempts + 1
      puts "ROOM COUNT: " + room_count.to_s
      puts "DOORS LENGTH: " + potential_doors.length.to_s

      #room more likely to spawn early - the less likely it becomes, the more likely it is to add a corridor
        current_room_size = 1 #rand(3)
        if (current_room_size == 0 and room_count_sm >= max_rooms_sm) or (current_room_size == 1 and room_count_md >= max_rooms_md) or (current_room_size == 2 and room_count_lg >= max_rooms_lg)
          next
        end

        #potential_room_x = rand(max_width)
        #potential_room_y = rand(max_height)

        #get a random wall tile
        random_value = nil
        while random_value.nil?
          random_key = rand(num_potential_doors)
          if potential_doors.key?(random_key)
            random_value = potential_doors[random_key]
          else
            attempts = attempts + 1
            if attempts >= 300
              break
            end
          end

        end
      if attempts >= 300
        break
      end

      potential_room_x = random_value['x']
      potential_room_y = random_value['y']
      wall_type = new_map[random_value['y']][random_value['x']]
      case wall_type
        when 2
          direction = 3
        when 3
          direction = 0
        when 4
          direction = 1
        when 5
          direction = 2
        when 6
          if rand(2) == 0
            direction = 3
          else
            direction = 2
          end
        when 7
          if rand(2) == 0
            direction = 0
          else
            direction = 3
          end
        when 8
          if rand(2) == 0
            direction = 1
          else
            direction = 0
          end
        when 9
          if rand(2) == 0
            direction = 2
          else
            direction = 1
          end
        else
          next
      end

        case current_room_size
          when 0
            puts "SMALL ROOM"





            if potential_room_x - 1 < 0 or potential_room_y - 2 < 0 or potential_room_x + 1 >= max_width or potential_room_y + 2 >= max_height
              next
            end
            #1 by 2 room, so only check the current space and the space above
            if new_map[potential_room_y][potential_room_x] == 1 or new_map[potential_room_y - 1][potential_room_x] == 1 or new_map[potential_room_y][potential_room_x] == 2 or new_map[potential_room_y - 1][potential_room_x] == 2
              next
            end

            for x in (potential_room_x - 1)..(potential_room_x + 1)
              for y in (potential_room_y - 2)..(potential_room_y + 1)
                if x == potential_room_x - 1 or x == potential_room_x + 1 or y == potential_room_y - 2 or y == potential_room_y + 1
                  new_map[y][x] = 1
                else
                  new_map[y][x] = 2
                end
              end
            end

            new_map[potential_door_y][potential_door_x] = 2

            room_count += 1
            room_count_sm += 1
          when 1

            case direction
              when 0
                potential_room_x += 2
              when 1
                potential_room_y += 2
              when 2
                potential_room_x -= 2
              when 3
                potential_room_y -= 2

            end

            if potential_room_x - 2 < 0 or potential_room_y - 2 < 0 or potential_room_x + 2 >= max_width or potential_room_y + 2 >= max_height
              potential_doors.delete(random_key)
              next
            end

            valid = true
            for x in (potential_room_x - 1)..(potential_room_x + 1)
              for y in (potential_room_y - 1)..(potential_room_y + 1)
                unless new_map[y][x].nil?
                  valid = false
                  break
                end
              end
              unless valid
                break
              end
            end
            unless valid
              potential_doors.delete(random_key)
              next
            end

            for x in (potential_room_x - 1)..(potential_room_x + 1)
              for y in (potential_room_y - 1)..(potential_room_y + 1)
                if x == potential_room_x - 1 && y == potential_room_y - 1
                  num_potential_doors += 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 6
                elsif x == potential_room_x + 1 && y == potential_room_y - 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 7
                elsif x == potential_room_x + 1 && y == potential_room_y + 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 8
                elsif x == potential_room_x - 1 && y == potential_room_y + 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 9
                elsif x == potential_room_x - 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 5
                elsif x == potential_room_x + 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 3
                elsif y == potential_room_y - 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 2
                elsif y == potential_room_y + 1
                  potential_doors = potential_doors.merge({num_potential_doors => {'x' => x, 'y' => y}})
                  new_map[y][x] = 4
                else
                  new_map[y][x] = 1
                end


                # if x == potential_room_x - 2 or x == potential_room_x + 2 or y == potential_room_y - 2 or y == potential_room_y + 2
                #   new_map[y][x] = 1
                # else
                #   new_map[y][x] = 2
                # end
              end
            end

            #remove unpotential doors
            old_door = random_value
            case direction
              when 0
                new_door = old_door.clone
                new_door['x'] += 1
              when 1
                new_door = old_door.clone
                new_door['y'] += 1
              when 2
                new_door = old_door.clone
                new_door['x'] -= 1
              when 3
                new_door = old_door.clone
                new_door['y'] -= 1
            end

            potential_doors.each do |door_key, door|
              puts 'OLD DOOR: ' + old_door['x'].to_s + ' ' + old_door['y'].to_s
              puts 'NEW DOOR: ' + new_door['x'].to_s + ' ' + new_door['y'].to_s
              puts 'TESTING DOOR:' + door['x'].to_s + ' ' + door['y'].to_s
              if (door['x'] == old_door['x'] and (door['y'] == old_door['y'] - 1 or door['y'] == old_door['y'] + 1)) or
                  (door['y'] == old_door['y'] and (door['x'] == old_door['x'] - 1 or door['x'] == old_door['x'] + 1)) or
                  (door['x'] == new_door['x'] and (door['y'] == new_door['y'] - 1 or door['y'] == new_door['y'] + 1)) or
                  (door['y'] == new_door['y'] and (door['x'] == new_door['x'] - 1 or door['x'] == new_door['x'] + 1))
puts "REMOVED"
                potential_doors.delete(door_key)
              end

            end
            case new_map[old_door['y']][old_door['x']]
              when 2
                new_map[old_door['y']][old_door['x']] = 1
              when 3
                new_map[old_door['y']][old_door['x']] = 1
              when 4
                new_map[old_door['y']][old_door['x']] = 1
              when 5
                new_map[old_door['y']][old_door['x']] = 1
              when 6
                if direction == 2
                  new_map[old_door['y']][old_door['x']] = 2
                else
                  new_map[old_door['y']][old_door['x']] = 5
                end
              when 7
                if direction == 3
                  new_map[old_door['y']][old_door['x']] = 3
                else
                  new_map[old_door['y']][old_door['x']] = 2
                end
              when 8
                if direction == 0
                  new_map[old_door['y']][old_door['x']] = 4
                else
                  new_map[old_door['y']][old_door['x']] = 3
                end
              when 9
                if direction == 1
                  new_map[old_door['y']][old_door['x']] = 5
                else
                  new_map[old_door['y']][old_door['x']] = 4
                end
            end


            case new_map[new_door['y']][new_door['x']]
              when 2
                new_map[new_door['y']][new_door['x']] = 1
              when 3
                new_map[new_door['y']][new_door['x']] = 1
              when 4
                new_map[new_door['y']][new_door['x']] = 1
              when 5
                new_map[new_door['y']][new_door['x']] = 1
              when 6
                if direction == 2
                  new_map[new_door['y']][new_door['x']] = 2
                else
                  new_map[new_door['y']][new_door['x']] = 5
                end
              when 7
                if direction == 3
                  new_map[new_door['y']][new_door['x']] = 3
                else
                  new_map[new_door['y']][new_door['x']] = 2
                end
              when 8
                if direction == 0
                  new_map[new_door['y']][new_door['x']] = 4
                else
                  new_map[new_door['y']][new_door['x']] = 3
                end
              when 9
                if direction == 1
                  new_map[new_door['y']][new_door['x']] = 5
                else
                  new_map[new_door['y']][new_door['x']] = 4
                end
            end


            room_count += 1
            room_count_md += 1
          when 2
            puts "LARGE ROOM"

            case direction % 4
              when 0
                potential_room_x += 3
              when 1
                potential_room_y += 3
              when 2
                potential_room_x -= 3
              when 3
                potential_room_y -= 3

            end
            if potential_room_x - 3 < 0 or potential_room_y - 3 < 0 or potential_room_x + 3 >= max_width or potential_room_y + 3 >= max_height
              room_probability -= 1
              next
            end

            valid = true
            for x in (potential_room_x - 2)..(potential_room_x + 2)
              for y in (potential_room_y - 2)..(potential_room_y + 2)
                if new_map[y][x] == 1 or new_map[y][x] == 2
                  valid = false
                  break
                end
              end
              unless valid
                break
              end
            end
            unless valid
              room_probability -= 1
              next
            end

            for x in (potential_room_x - 3)..(potential_room_x + 3)
              for y in (potential_room_y - 3)..(potential_room_y + 3)
                if x == potential_room_x - 3 or x == potential_room_x + 3 or y == potential_room_y - 3 or y == potential_room_y + 3
                  new_map[y][x] = 1
                else
                  new_map[y][x] = 2
                end
              end
            end
            new_map[potential_door_y][potential_door_x] = 2


            room_count += 1
            room_count_lg += 1
            room_probability = room_count * 10
        end

      end

      if attempts < 300 and potential_doors.length > 0
        valid_loop = true
      end

    end


    self.map = flatten_map(new_map)

  end

  def flatten_map(new_map)
    puts "FLATTENING MAP..."
    new_map_string = ''
    new_map.each do |row|
      row.each do |cell|
        new_map_string << (cell.nil? ? 0.to_s : cell.to_s)
      end
      new_map_string << 'n'
    end
    new_map_string
  end
end
