# frozen_string_literal: true

require 'roo'

namespace :import do
  desc 'Import users from xlsx files'

  task from_xlsx: :environment do
    puts 'Importing Data'

    data = Roo::Spreadsheet.open('db/users.xlsx') # открыть таблицу xlsx

    headers = data.row(1) # получить строку заголовка

    data.each_with_index do |row, idx|
      next if idx.zero? # пропустить строку заголовка

      # создать хеш из заголовков и ячеек
      user_data = [headers, row].transpose.to_h

      # переход на следующую итерацию, если юзер уже существует
      if User.exists?(email: user_data['email'])
        puts "User with email #{user_data['email']} already exists"

        next
      end

      user = User.new(user_data)
      user.role = 'basic'
      user.status = 'activated'

      puts "Saving User with email '#{user.email}'"

      user.save!
    end
  end
end
