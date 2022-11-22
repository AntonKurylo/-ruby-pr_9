def print_pie(pie, result_hash)
  k = 0
  puts "\nSliced pie:\n["
  result_hash.each_value do |value|
    start_r = value[0][0]
    start_c = value[0][1]
    end_r = value[1][0]
    end_c = value[1][1]
    # puts "#{start_r} - #{end_r}, #{start_c} - #{end_c}"

    (start_r..end_r).each do |r|
      (start_c..end_c).each do |c|
        print("#{pie[r][c]}")
      end
      puts "\n"
    end

    k += 1
    puts "," if k != result_hash.length
  end
  puts "]\n"
end

def cut_pie(pie, row_col_index, piece_area, raisins_amount, result_hash)
  is_raisin = false
  is_right = true
  is_piece_area = false
  start_r = row_col_index.dig(:r)
  start_c = row_col_index.dig(:c)
  end_r = 0
  end_c = 0

  if raisins_amount == 0
    return true
  end

  # puts "\nstart: r = #{start_r}, c = #{start_c}"

  (start_r..pie.length - 1).each do |r|
    break if is_piece_area or !is_right
    (start_c..pie[r].length - 1).each do |c|
      # puts "pie[#{r}][#{c}] = #{pie[r][c]}"
      if !pie[r][c].eql?("o")
        if ((r - start_r + 1) * (c - start_c + 1)) == piece_area
          row_col_index[:r] = r + 1
          # puts "end: r = #{r} c = #{c}"
          end_r = r
          end_c = c
          is_piece_area = true
          break
        end
      elsif pie[r][c].eql?("o") and !is_raisin
        # puts "is_raisin = #{is_raisin}"
        # puts "raisin: r = #{r} c = #{c}"
        is_raisin = true
        # puts "is_raisin = #{is_raisin}"
      else
        is_right = false
        break
      end
    end
  end
  # puts "is_piece_area = #{is_piece_area}"
  is_raisin = false
  is_right = true

  if !is_piece_area
    # puts "Vertical"
    (start_r..pie[0].length - 1).each do |c|
      break if is_piece_area or !is_right
      (start_c..pie.length - 1).each do |r|
        # puts "pie[#{r}][#{c}] = #{pie[r][c]}"

        if !pie[r][c].eql?("o")
          if ((r - start_r + 1) * (c - start_c + 1)) == piece_area
            row_col_index[:c] = c + 1
            # puts "end: r = #{r} c = #{c}"
            end_r = r
            end_c = c
            is_piece_area = true
            break
          end
        elsif pie[r][c].eql?("o") and !is_raisin
          # puts "is_raisin = #{is_raisin}"
          # puts "raisin: r = #{r} c = #{c}"
          is_raisin = true
          # puts "is_raisin = #{is_raisin}"
        else
          is_right = false
          break
        end
      end
    end
  end
  # puts "row_col_index = #{row_col_index}"
  result_hash.store("res#{result_hash.length}", [[start_r, start_c], [end_r, end_c]])

  cut_pie(pie, row_col_index, piece_area, raisins_amount - 1, result_hash)
end

cake_1 = "........
..o.....
...o....
........
"
cake_2 = ".o......
......o.
....o...
..o.....
"
cake_3 = ".o.o....
........
....o...
........
.....o..
........
"

pie = Array.new

cake_1.split("\n").each do |r|
  pie << r.split("").to_a
end
pie.each { |r| puts "#{r}\n" }

pie_size = pie.length * pie[0].length
raisins_amount = 0
result_hash = Hash.new
row_col_index = { "r": 0, "c": 0 }

(0..pie.length - 1).each do |r|
  (0..pie[r].length - 1).each do |c|
    raisins_amount += 1 if pie[r][c].eql?("o")
  end
end

piece_area = pie_size / raisins_amount
puts "\npie_size = #{pie_size}"
puts "raisins_amount = #{raisins_amount}"
puts "piece_area = #{piece_area }"

cut_pie(pie, row_col_index, piece_area, raisins_amount, result_hash)
print_pie(pie, result_hash)
