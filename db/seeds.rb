# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create email: 'elizabeth-olsen@gmail.com',
            name: 'Elizabeth',
            username: 'Scarlet_Witch',
            password: 'Elizabeth1989!',
            password_confirmation: 'Elizabeth1989!',
            role: 'basic',
            status: 'activated'

# сгенерировать 5 вопросов вновь созданного пользователя "user"
# 5.times do
#   body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
#   question = user.questions.build text: body
#   question.save
# end

# Нашли всех юзеров и после того как хэш пересчитали, юзеров сохранили
# "u.send(:set_gravatar_hash)" - вызов закрытого (под "private") метода
# User.find_each do |u|
#   u.send(:set_gravatar_hash)
#   u.save
# end
