class Game < ApplicationRecord

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
        new_map[key][0] = '1'
        new_map[key][max_width - 1] = '1'
        key = key + 1
      end
      key = 0
      new_map[0].each do |n|
        new_map[0][key] = '1'
        key = key + 1
      end
      key = 0
      new_map[max_height - 1].each do |n|
        new_map[max_height - 1][key] = '1'
        key = key + 1
      end

      room_count = 0
      room_count_sm = 0
      room_count_md = 0
      room_count_lg = 0

      max_rooms = 10
      max_rooms_sm = 4
      max_rooms_md = 4
      max_rooms_lg = 4

      starting_room_x = 0
      starting_room_y = 0

      corridor_tiles = {}
      attempts = 0


      while room_count == 0

        potential_room_x = rand(max_width)
        potential_room_y = rand(max_height)
        if potential_room_x - 3 < 0 or potential_room_y - 3 < 0 or potential_room_x + 3 >= max_width or potential_room_y + 3 >= max_height
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
        if room_count_lg == 0
          new_map[potential_room_y][potential_room_x] = 'p'
          starting_room_x = potential_room_x
          starting_room_y = potential_room_y
        end

        room_count += 1
        room_count_lg += 1
      end

      #first hallway
      current_position_x = starting_room_x
      current_position_y = starting_room_y
      while corridor_tiles.empty?

        #wander the room until you reach a wall

        direction = rand(4)
        case direction
          when 0
            current_position_x += 1
            if current_position_x >= max_width - 2
              current_position_x -= 6
              direction += 2
            end
          when 1
            current_position_y += 1
            if current_position_y >= max_height - 2
              current_position_y -= 6
              direction += 2
            end
          when 2
            current_position_x -= 1
            if current_position_x <= 1
              current_position_x += 6
              direction -= 2
            end
          when 3
            current_position_y -= 1
            if current_position_y <= 1
              current_position_y += 6
              direction -= 2
            end
        end

        unless new_map[current_position_y][current_position_x] == 1
          next
        end

        potential_door_x = current_position_x
        potential_door_y = current_position_y
        new_map[current_position_y][current_position_x] = 2
        case direction
          when 0
            current_position_x += 1
          when 1
            current_position_y += 1
          when 2
            current_position_x -= 1
          when 3
            current_position_y -= 1
        end
        new_map[current_position_y][current_position_x] = 0
        corridor_tiles = {0 => {'x' => current_position_x, 'y' => current_position_y}}
        direction = rand(4)

        while corridor_tiles.length < 5 and attempts < 50

          puts "CORRIDOR LENGTH: " + corridor_tiles.length.to_s
          case direction
            when 0
              current_position_x += 1
              if current_position_x >= max_width
                current_position_x -= 4
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_x -= 1
                direction = rand(4)
                attempts += 1
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_x -= 1
                direction = (direction + 2) % 4
                attempts += 1
              end
            when 1
              current_position_y += 1
              if current_position_y >= max_height
                current_position_y -= 4
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_y -= 1
                direction = rand(4)
                attempts += 1
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_y -= 1
                direction = (direction + 2) % 4
                attempts += 1
              end
            when 2
              current_position_x -= 1
              if current_position_x < 0
                current_position_x += 4
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_x += 1
                direction = rand(4)
                attempts += 1
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_x += 1
                direction = (direction + 2) % 4
                attempts += 1
              end
            when 3
              current_position_y -= 1
              if current_position_y < 0
                current_position_y += 4
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_y += 1
                direction = rand(4)
                attempts += 1
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_y += 1
                direction = (direction + 2) % 4
                attempts += 1
              end
          end


          if new_map[current_position_y][current_position_x] != 0
            puts "ADDING TO MAP"
            new_map[current_position_y][current_position_x]
            corridor_tiles = corridor_tiles.merge({corridor_tiles.length => {'x' => current_position_x, 'y' => current_position_y}})
          else
            attempts += 1
          end
        end
        if attempts >= 50
          break
        else
          valid_loop = true
        end
      end

    end


    room_probability = 100
    while room_count < max_rooms

      puts "ROOM COUNT: " + room_count.to_s
      current_room_probability = rand(100)

      #room more likely to spawn early - the less likely it becomes, the more likely it is to add a corridor
      if current_room_probability < room_probability
        current_room_size = rand(3)
        if (current_room_size == 0 and room_count_sm >= max_rooms_sm) or (current_room_size == 1 and room_count_md >= max_rooms_md) or (current_room_size == 2 and room_count_lg >= max_rooms_lg)
          next
        end

        #potential_room_x = rand(max_width)
        #potential_room_y = rand(max_height)

        #get a random corridor tile
        values = corridor_tiles.values
        random_value = values[rand(values.size)]
        direction = rand(4)
        valid = false
        while direction < 8
          case direction % 4
            when 0
              if new_map[random_value['y']][random_value['x'] + 1].nil?
                valid = true
                potential_room_x = random_value['x'] + 1
                potential_room_y = random_value['y']
                break
              else
                direction += 1
              end
            when 1
              if new_map[random_value['y'] + 1][random_value['x']].nil?
                valid = true
                potential_room_x = random_value['x']
                potential_room_y = random_value['y'] + 1
                break
              else
                direction += 1
              end
            when 2
              if new_map[random_value['y']][random_value['x'] - 1].nil?
                valid = true
                potential_room_x = random_value['x'] - 1
                potential_room_y = random_value['y']
                break
              else
                direction += 1
              end
            when 3
              if new_map[random_value['y'] - 1][random_value['x']].nil?
                valid = true
                potential_room_x = random_value['x']
                potential_room_y = random_value['y'] - 1
                break
              else
                direction += 1
              end
          end
        end

        if (valid == false and direction >= 8)
          next
        end
        potential_door_x = potential_room_x
        potential_door_y = potential_room_y

        case current_room_size
          when 0
            puts "SMALL ROOM"


            case direction % 4
              when 0
                potential_room_x += 1
              when 1
                potential_room_y += 2
              when 2
                potential_room_x -= 1
              when 3
                potential_room_y -= 1

            end

            if potential_room_x - 1 < 0 or potential_room_y - 2 < 0 or potential_room_x + 1 >= max_width or potential_room_y + 2 >= max_height
              room_probability -= 1
              next
            end
            #1 by 2 room, so only check the current space and the space above
            if new_map[potential_room_y][potential_room_x] == 1 or new_map[potential_room_y - 1][potential_room_x] == 1 or new_map[potential_room_y][potential_room_x] == 2 or new_map[potential_room_y - 1][potential_room_x] == 2
              room_probability -= 1
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
            room_probability = room_count * 10
          when 1
            puts "MEDIUM ROOM"

            case direction % 4
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
              room_probability -= 1
              next
            end

            valid = true
            for x in (potential_room_x - 1)..(potential_room_x + 1)
              for y in (potential_room_y - 1)..(potential_room_y + 1)
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

            for x in (potential_room_x - 2)..(potential_room_x + 2)
              for y in (potential_room_y - 2)..(potential_room_y + 2)
                if x == potential_room_x - 2 or x == potential_room_x + 2 or y == potential_room_y - 2 or y == potential_room_y + 2
                  new_map[y][x] = 1
                else
                  new_map[y][x] = 2
                end
              end
            end
            new_map[potential_door_y][potential_door_x] = 2

            room_count += 1
            room_count_md += 1
            room_probability = room_count * 10
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

      # add a corridor
      else
        if corridor_tiles.length > 150
          room_probability = 100
          next
        end
        puts "CORRIDORS: " + corridor_tiles.length.to_s
        values = corridor_tiles.values
        random_value = values[rand(values.size)]
        direction = rand(4)
        valid = false
        while direction < 8
          case direction % 4
            when 0
              if new_map[random_value['y']][random_value['x'] + 1].nil?
                valid = true
                potential_room_x = random_value['x'] + 1
                potential_room_y = random_value['y']
                break
              else
                direction += 1
              end
            when 1
              if new_map[random_value['y'] + 1][random_value['x']].nil?
                valid = true
                potential_room_x = random_value['x']
                potential_room_y = random_value['y'] + 1
                break
              else
                direction += 1
              end
            when 2
              if new_map[random_value['y']][random_value['x'] - 1].nil?
                valid = true
                potential_room_x = random_value['x'] - 1
                potential_room_y = random_value['y']
                break
              else
                direction += 1
              end
            when 3
              if new_map[random_value['y'] - 1][random_value['x']].nil?
                valid = true
                potential_room_x = random_value['x']
                potential_room_y = random_value['y'] - 1
                break
              else
                direction += 1
              end
          end
        end

        if (valid == false and direction >= 8)
          next
        end

        current_position_x = potential_room_x
        current_position_y = potential_room_y
        attempts = 0
        corridors_added = 0
        while attempts < 50 and corridors_added < 5
          case direction
            when 0
              current_position_x += 1
              if current_position_x >= max_width
                current_position_x -= 1
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_x -= 1
                direction = rand(4)
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_x -= 1
                direction = (direction + 1) % 4
              end
            when 1
              current_position_y += 1
              if current_position_y >= max_height
                current_position_y -= 1
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_y -= 1
                direction = rand(4)
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_y -= 1
                direction = (direction + 1) % 4
              end
            when 2
              current_position_x -= 1
              if current_position_x < 0
                current_position_x += 1
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_x += 1
                direction = rand(4)
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_x += 1
                direction = (direction + 1) % 4
              end
            when 3
              current_position_y -= 1
              if current_position_y < 0
                current_position_y += 1
                direction = rand(4)
                attempts += 1
                next
              end
              if new_map[current_position_y][current_position_x] == 2
                current_position_y += 1
                direction = rand(4)
                next
              elsif new_map[current_position_y][current_position_x] == 1
                current_position_y += 1
                direction = (direction + 1) % 4
              end
          end

          if !new_map[current_position_y][current_position_x].nil?
            attempts += 1
          else
            attempts += 1
            corridors_added += 1
            new_map[current_position_y][current_position_x] = 0
            corridor_tiles = corridor_tiles.merge({corridor_tiles.length => {'x' => current_position_x, 'y' => current_position_y}})
          end
        end
        room_probability = 100

      end


    end



    self.map = flatten_map(new_map)

  end

  def flatten_map(new_map)
    new_map_string = ''
    new_map.each do |row|
      row.each do |cell|
        new_map_string << (cell.nil? ? 1.to_s : cell.to_s)
      end
      new_map_string << 'n'
    end
    new_map_string
  end
end
