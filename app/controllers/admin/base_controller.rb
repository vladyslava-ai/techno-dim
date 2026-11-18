module Admin
  class BaseController < ApplicationController           # власний код: спільна перевірка ролі (RBAC)
    before_action :require_admin
  end
end
