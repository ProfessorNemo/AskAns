# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    # принимает запись для авторизации и запрос (которого здесь нет)
    def authorize(record, query = nil)
      super([:admin, record], query)
    end
  end
end

# м-д "authorize" будет вызывать родительский м-д, но он будет дописывать
# "super([:admin, record], query)", где "admin" - то пространство имен, где
# лежит наша политика (module Admin - ./policies/admin/user_policies.rb)
# query - не будет

# можно было записать, как: "authorize [:admin, user]". Но везде писать ":admin"
# не охота. Поэтому для админского контроллера по умолчанию будем добавлять ":admin"
# во все проверки прав доступа.
